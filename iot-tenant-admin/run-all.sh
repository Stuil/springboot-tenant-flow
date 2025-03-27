#!/bin/sh
# java安装目录
export JAVA_HOME=/home/app/jdk/jdk1.8.0_202/
export JRE_HOME=$JAVA_HOME/jre


# 端口号
PORTS=(8080)
# 模块
MODULES=(hh-admin)
# 模块名称
MODULE_NAMES=(猴猴的生活馆)
# jar包数组
JARS=(hh-admin.jar)
# jar包路径
JAR_PATH='/home/app/hh-vue'
# 日志路径
LOG_PATH='/home/app/hh-vue'
JVM_OPTS="-Dname=$JARS  -Duser.timezone=Asia/Shanghai -Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDateStamps  -XX:+PrintGCDetails -XX:NewRatio=1 -XX:SurvivorRatio=30 -XX:+UseParallelGC -XX:+UseParallelOldGC"

# 启动方法
start() {
  echo "----------启动服务----------"
  local MODULE=
  local MODULE_NAME=
  local JAR_NAME=
  local command="$1"
  local commandOk=0
  local count=0
  local okCount=0
  local port=0
  for((i=0;i<${#MODULES[@]};i++))
  do
    MODULE=${MODULES[$i]}
    MODULE_NAME=${MODULE_NAMES[$i]}
    JAR_NAME=${JARS[$i]}
    PORT=${PORTS[$i]}
    if [ "$command" == "all" ] || [ "$command" == "$MODULE" ];then
      commandOk=1
      count=0
      if [ ! -d $LOG_PATH ];then
        mkdir $LOG_PATH
      fi
      PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
      if [ -n "$PID" ];then
        echo "$MODULE---$MODULE_NAME:已经运行,PID=$PID"
      else
          #这行命令根据自己的需要更改
        cd $JAR_PATH && nohup $JAVA_HOME/bin/java $JVM_OPTS -jar $JAR_NAME --server.port=$PORT >> $LOG_PATH/$MODULE.log 2>&1 &
        PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
        while [ -z "$PID" ]
        do
          if (($count == 10));then
            echo "$MODULE---$MODULE_NAME:$(expr $count \* 10)秒内未启动,请检查!"
            break
          fi
          count=$(($count+1))
          echo "$MODULE_NAME启动中..."
          sleep 10s
          PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
        done
        okCount=$(($okCount+1))
        echo "$MODULE---$MODULE_NAME:已经启动成功,PID=$PID"
      fi
    fi
  done
  if(($commandOk == 0));then
    echo "第二个参数输入错误"
  else
    echo "----本次共启动:$okCount个服务----"
  fi
}

# 停止方法
stop() {
  echo "----------停止服务----------"
  local MODULE=
  local MODULE_NAME=
  local JAR_NAME=
  local command="$1"
  local commandOk=0
  local okCount=0
  for((i=0;i<${#MODULES[@]};i++))
  do
    MODULE=${MODULES[$i]}
    MODULE_NAME=${MODULE_NAMES[$i]}
    JAR_NAME=${JARS[$i]}
    if [ "$command" = "all" ] || [ "$command" = "$MODULE" ];then
      commandOk=1
      PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
      if [ -n "$PID" ];then
        echo "$MODULE---$MODULE_NAME:准备结束,PID=$PID"
        kill -9 $PID
        PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
        while [ -n "$PID" ]
        do
          sleep 3s
          PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
        done
        echo "$MODULE---$MODULE_NAME:成功结束"
        okCount=$(($okCount+1))
      else
        echo "$MODULE---$MODULE_NAME:未运行"
      fi
    fi
  done
  if (($commandOk == 0));then
    echo "第二个参数输入错误"
  else
    echo "----本次共停止:$okCount个服务----"
  fi
}

# 检查运行状态
status(){
  echo "------检查服务运行状态------"
  local MODULE=
  local MODULE_NAME=
  local JAR_NAME=
  local command="$1"
  local commandOk=0
  local okCount=0
  for((i=0;i<${#MODULES[@]};i++))
  do
    MODULE=${MODULES[$i]}
    MODULE_NAME=${MODULE_NAMES[$i]}
    JAR_NAME=${JARS[$i]}
    if [ "$command" = "all" ] || [ "$command" = "$MODULE" ];then
      commandOk=1
      PID=`ps -ef |grep $(echo $JAR_NAME | awk -F/ '{print $NF}') | grep -v grep | awk '{print $2}'`
      if [ -n "$PID" ];then
        echo "$MODULE---$MODULE_NAME:正在运行,PID=$PID"
        okCount=$(($okCount+1))
      else
        echo "$MODULE---$MODULE_NAME:未运行"
      fi
    fi
  done
  if (($commandOk == 0));then
    echo "第二个参数输入错误"
  else
    echo "------正在运行:$okCount个服务------"
  fi
}

# 根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
  start)
    start "$2"
  ;;
  stop)
    stop "$2"
  ;;
  status)
    status "$2"
  ;;
  restart)
    stop "$2"
    sleep 3s
    start "$2"
  ;;
  *)
    echo "sh startAll.sh [start|stop|restart|status] [all|模块名]"
    exit 1
  ;;
esac
exit 0