import asyncio
from random import randint

'''
call_soon -> stack task(function)
'''
def random_hit(future, n, loop, count=1):
    if randint(1, n) == n:
        print("Hit")
        future.set_result(count)
    else:
        print("Not yet")
        count += 1
        loop.call_soon(random_hit, future, n, loop, count)


def hello(loop):
    print("hello")
    loop.call_soon(hello, loop)

loop = asyncio.get_event_loop()
future = loop.create_future()
loop.call_soon(random_hit, future, 3, loop)
loop.call_soon(hello, loop)
result = loop.run_until_complete(future)
print(f"end: {result}")
