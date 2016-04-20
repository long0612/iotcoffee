import json, requests
import socket, time
from datetime import datetime


# POSTS the data into the cloud server
def postBBB(bufferdata):
    r = requests.get('http://swarmnuc009.ifp.illinois.edu:8956')
    #r = requests.get('http://requestb.in/1eymyoo1')
    #print r.status_code
    if r.status_code == 200:
        DB = 'publicDb'
        USER = 'nan'
        PWD = 'publicPwd'
        EVENT = 'event'
        payload = {'dbname': DB, 'user': USER, 'passwd': PWD, 'colname': EVENT}
        #print 'POST'
        r = requests.post('http://swarmnuc009.ifp.illinois.edu:8956/col', params=payload, json=bufferdata)
        #r = requests.post('http://requestb.in/1eymyoo1', params=payload, json=data)
        print "content: ", r.content, r.status_code
    return

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# Make sure multiple clients can use the broadcast
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(('255.255.255.255', 3002))
ctr = 0
counterPB1 = 0
counterBLEE1 = 0
bufferBLEE1 = [0 for x in xrange(0, 10)]
bufferPB1 = [0 for x in xrange(0, 10)]
while True:
    #print 'Reading ', ctr + 1
#   r = requests.get('http://swarmnuc009.ifp.illinois.edu:8956')

    message = s.recvfrom(1024)
    timestamp = (datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3]+'Z')
    adv_obj = json.loads(message[0])
    adv_obj.update({'filename': 'bbbTest'})
    adv_obj.update({'recordDate':{'$date': timestamp}})

    # PowerBlade
    if(adv_obj['id'] == 'c098e5700024'):
        if(counterPB1 == 10):
            #print 'PowerBlade Reading: ', bufferPB1[4]
            counterPB1 = 0
            postBBB(bufferPB1[4])
        bufferPB1[counterPB1] = adv_obj
        counterPB1 += 1
        # BLEE
    if(adv_obj['id'] == 'c098e5300013'):
        if(counterBLEE1 == 10):
            #print 'BLEE Reading: ', bufferBLEE1[4]
            counterBLEE1 = 0
            postBBB(bufferBLEE1[4])
        bufferBLEE1[counterBLEE1] = adv_obj
        counterBLEE1 += 1

        #if r.status_code == 200 and (countPB1 == 0 or counterBLEE1 == 0):
            #DB = 'publicDb'
            #USER = 'nan'
            #PWD = 'publicPwd'
            #EVENT = 'event'#

            #POST
            #payload = {'dbname': DB, 'user': USER, 'passwd': PWD, 'colname': EVENT}
            #data = {'bbb': adv_obj, 'filename': 'bbbTest'}
            #data = bufferPB1[4] if countPB1 == 0 else counterBLEE1
            #r = requests.post('http://swarmnuc009.ifp.illinois.edu:8956/col', params=payload, json=data)
            #r = requests.post('http://requestb.in/r76spwr7', params=payload, json=data)
            #r = requests.post('http://swarmnuc009.ifp.illinois.edu:8956/col', params=payload, json=data)
            #GET
            #payload2 = {'dbname': DB, 'user': USER, 'passwd': PWD, 'colname': EVENT, 'filename': 'bbbTest'}
            #r = requests.get('http://swarmnuc009.ifp.illinois.edu:8956/col', params=payload2)
            #print("content: ", r.content)
    ctr+=1
r.close()
