import asyncio

# sleep
async def my_sleep(loop):
    print("start")
    result = None
    future = loop.create_future()
    h = loop.call_later(2, future.set_result, result)
    return (await future)

# will call function in sleep
def call_in_sleep():
    print("call in sleep")


loop = asyncio.get_event_loop()
future = my_sleep(loop)
loop.run_until_complete(future)
loop.close()

