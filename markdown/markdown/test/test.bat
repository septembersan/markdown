echo *************************START***************************** > test_mc.log 2>&1
echo [clustat: starting] >> test_mc.log
clustat >> test_mc.log 2>&1

echo [cluctrl start-resource] >> test_mc.log
start cluctrl "C:\Users\hiroomi\Documents\Visual Studio 2015\Projects\ConsoleApplication1\ConsoleApplication1\bin\Debug\rmc.log"
rem cluctrl start-resource rmc.log >> test_mc.log 2>&1
tail.exe rmc.log >> test_mc.log 2>&1

echo [clustat: started] >> test_mc.log
clustat >> test_mc.log 2>&1
