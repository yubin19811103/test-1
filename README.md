# ansible的一个项目
# 1. 所有项目都是在hosts文件里配置
# 2. mysql安装除了hosts文件外，还需要配置rep.sql.j2
#    mysql 说明：
#    slave需要用到master的变量，修改master的ip的时候同时也需要修改rep.sql.j2里的的ip
