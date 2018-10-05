def sub_generator():
    print('    sub generator 開始')
    print('    ... そして値を yield します。')
    ret = yield 1
    print('    sub generator が再開し、 send された値を受け取りました:', ret)
    print('    ... そして別の値を return します。')
    return 42


def generator():
    print('  generator 開始')
    print('  ... そして sub generator を yield from します。')
    ret = yield from sub_generator()
    print('  generator が再開し、 sub generator から値を受け取りました:', ret)
    print('  何か値を return し、終了します。')
    return 'done'


print('generator を作って、')
g = generator()
print('... そして開始します。')
ret = g.send(None)
print('(sub) generator が停止し、そこから yield された値を受け取りました:', ret)
print('generator を再開します。')

try:
    g.send(2)

except StopIteration as e:
    # generator は終了時に StopIteration 例外を起こし、
    # return された値はその `value` attribute に入ります。
    print('generator が終了し、値を返しました:', e.value)

else:
    assert False
