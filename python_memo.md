## decorator
If use decorator, give decorator side function the following
``` py
import functools

def hoge_decorator(f):
    @functools.wraps(f)
    def hoge_wrapper(*args, **kwargs):
        """デコレータのDocstringだよ"""
        print("デコレータだよ")
        return f(*args, **kwargs)
    return hoge_wrapper

@hoge_decorator
def hoge_function():
    """デコってる関数のDocstringだよ"""
    print("これがデコってる関数だ！")
```

## coroutine 
working as method object.

``` py
loop.call_soon(callback, *for_callback_args)
loop.call_later(delay_time, callback, *for_callback_args)
```

execution event loop
``` py
loop.run_forever()
```


``` py
# get event loop
loop = asyncio.get_event_loop()

# shceduling event loop
loop.call_soon(callback)

# execution event loop
loop.run_forever()

# stop event loop
loop.stop()

# close event loop
loop.close()
```

## Future
Future is future result object.
Return Future object for the time being.
If process end, set Future object the result.
1. checking status  : (done, cancelled)
2. pull value       : (result, exception)
3. end              : (set_result, set_exception, cancel)
4. setting callback : (add_done_callback, remove_done_callback)

create Future object
``` py
loop.create_future()
```

loop.run_forever -> loop.run_until_complete(future)
If process end(set_result), loop.run_until_complete() finish automatically
``` py
loop.run_until_complete(future)
```

## asyncio
call_soonで関数オブジェクトをスタックするイメージ
call_soonでスタックした関数オブジェクトはloopで順次実行される

In async.loop
    call_soon(func1) -> stack func1
    call_soon(func2) -> stack func2
## ipython
### auto import
1. create startup file for auto import
    ``` sh
    cd .ipython/profile_default/startup/
    vi auto_import.ipy
    ```
2. To write import targets
    ex) import sys  
    ex) import os

3. optional
    create in the order  
    * [0-9].filename.py

### setup.py
* command  : greet
* namepace : helloworld.hello

* directory tree
    ./helloworld
    ./helloworld/__init__.py
    ./helloworld/hello.py
    ./setup.py

* hello.py
    ``` py
    #!/usr/bin/env python
    # -*- coding: utf-8 -*-


    def greet():
        print 'Hello, world!'


    def main():
        greet()

    if __name__ == '__main__':
        main()
    ```

* setup.py
    ``` py
    setup(name='helloworld',
        version='0.0.1',
        packages=find_packages(),
        entry_points="""
        [console_scripts]
        greet = helloworld.hello:main
        """,)
    ```

