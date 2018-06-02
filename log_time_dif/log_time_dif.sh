#!/bin/bash

if [ $# -ne 1 ];
then
    echo "Usage: $0 filename";
    exit -1
fi

filename=$1

git_version() {
    local cmd="git"
    if command -v "$cmd" 2>&1 >/dev/null; then
        ver=$("$cmd" --version | head -n 1)
    else
        ver="missing"
    fi

    printf "%s" "$ver"
}

function compare_time()
{
    # printf "%s\n" $1
    # printf "%s\n" $2

    #分割操作不能直接使用参数全局变量，所以定义临时变量赋值
    local aa=$1
    local bb=$2

    local hour1=${aa:0:2}
    local minute1=${aa:3:2}
    local second1=${aa:6:2}

    local hour2=${bb:0:2}
    local minute2=${bb:3:2}
    local second2=${bb:6:2}

    local dif=$[ $[ 10#$hour2*3600 + 10#$minute2*60 + 10#$second2 ] - $[ 10#$hour1*3600 + 10#$minute1*60 + 10#$second1 ] ]

    if [ $dif -ge 7 ]; then
        echo 1
        return 1
    else
        echo 0
        return 0
    fi
}

printf "%s\n" "----------------------------"

printf "%20s: %s\n" "git" "$(git_version)"


#使用shell函数版
export -f compare_time
awk 'BEGIN{ print "Start"; last_time = 0; now_time = 0;}
    {
        if(match($0, /(APP_Test1Timer EXPIRED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)/))
        {
            now_time = substr($0, 2, 8)

            # print last_time
            # print now_time

            # ddd=system("compare_time "last_time" "now_time)
            
            "compare_time "last_time" "now_time|getline ddd

            if(ddd > 0)
            {
                print;
            }
            else
            {

            }

            last_time = now_time;
        }
        else
        {

        }
    }
    END{ print "End" }' \
    $filename

#仅使用awk程序版
awk 'BEGIN{ print "Start"; last_time = 0; now_time = 0;}
    {
        if(match($0, /(APP_Test1Timer EXPIRED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)/))
        {
            hour = substr($0, 2, 2)
            minute = substr($0, 5, 2)
            second = substr($0, 8, 2)

            now_time = hour*3600 + minute * 60 + second

            # print last_time
            # print now_time

            if((now_time - last_time) > 7)
            {
                print;
            }
            else
            {

            }

            last_time = now_time;
        }
        else
        {

        }
    }
    END{ print "End" }' \
    $filename

printf "%s\n" "----------------------------"

exit 0
