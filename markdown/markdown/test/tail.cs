using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace tail
{
    class Program
    {
        static int timeOut;
        static void Main(String[] args)
        {
            //string[] cmds = System.Environment.GetCommandLineArgs();
            //timeOut = Int32.Parse(cmds[1]);

            Action<String[]> f = Usage;
            if (CheckArgs(args)) f = tail;
            f.Invoke(args);
        }

        #region "使い方と引数チェック"
        /// <summary>
        /// 引数チェック
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        static Boolean CheckArgs(String[] args)
        {
            args = args.Length == 0 ? new String[] { @"/?" } : args;
            return File.Exists(args[0]);
        }

        /// <summary>
        /// 使い方
        /// </summary>
        /// <param name="args"></param>
        static void Usage(String[] args)
        {
            Console.WriteLine(
                    String.Format("tail(-f param type only).\nUsage:{0} fileanme\n"
                                        , Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location)
                     )
            );
        }
        #endregion

        #region "tail本体"
        static void tail(String[] args)
        {
            FileInfo fi = new FileInfo(args[0]);
            using (FileStream stream = fi.Open(FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                Boolean state = false;
                int size = (int)fi.Length;
                stream.Seek(size, SeekOrigin.Current);
                using (FileSystemWatcher fw = new FileSystemWatcher(fi.DirectoryName, fi.Name))
                {
                    #region "イベントハンドラー用メソッド"
                    Action<Object, FileSystemEventArgs> ReadText = (sender, e) =>
                    {
                        fi.Refresh();
                        Byte[] al = new Byte[] { };
                        int RemainingSize = (int)fi.Length - size;
                        if (RemainingSize <= 0) return;
                        Array.Resize<Byte>(ref al, RemainingSize);
                        int result = stream.Read(al, 0, RemainingSize);
                        size = (int)fi.Length;
                        //Console.Write(Encoding.GetEncoding("sjis").GetString(al));
                        Console.WriteLine(Encoding.GetEncoding("sjis").GetString(al));
                    };
                    Action<object, ConsoleCancelEventArgs> EventStop = (sender, e) =>
                    {
                        fw.EnableRaisingEvents = false;
                        state = true;
                    };
                    #endregion
                    fw.NotifyFilter = NotifyFilters.Size;
                    Console.CancelKeyPress += new ConsoleCancelEventHandler(EventStop);
                    fw.Changed += new FileSystemEventHandler(ReadText);
                    fw.EnableRaisingEvents = true;
                    while (!state) ;
                }
            }
            Console.WriteLine("\nStopped.");
        }
        #endregion
    }
}
