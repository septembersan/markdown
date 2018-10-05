import functools


def coroutine(func):
    @functools.wraps(func)
    def wapper(*args, **kwargs):
        result = func(*args, **kwargs)
        next(result)
        return result
    return wapper


@coroutine
def recv():
    print("Started.")
    while True:
        v = yield
        print(f"Receive: {v}")


gen = recv()
next(gen)
