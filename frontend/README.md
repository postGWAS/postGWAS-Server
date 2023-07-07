# 开发规范

## java开发规范

### 编程规范

1. 项目命名规范

   全部采用小写，中划线分割的形式

   正例：`mall-management-system / order-service-client / user-api`

   反例：`mall_management-system / mallManagementSystem / orderServiceClient`

2. TODO/FIXME规范

   TODO：如果代码中有该标识，说明在标识处有功能代码待编写，待实现的功能在说明中会简略说明

   ```
   // TODO <author-name>: 补充XX处理 <time>: 创建TODO的时间
   ```

   FIXME：如果代码中有该标识，说明标识处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。

   ```
   // FIXME <author-name>: XX缺陷 <time>: 创建FIXME的时间
   ```

3. 方法注释

   方法要尽量通过方法名自解释，不要写无用、信息冗余的方法头，不要写空有格式的方法头注释。

   方法头注释内容可选，但不限于：功能说明、返回值，用法、算法实现等等。尤其是对外的方法接口声明，其注释，应当将重要、有用的信息表达清楚。

   ```java
   /**
    * 解析转换时间字符串为 LocalDate 时间类
    * 调用前必须校验字符串格式 否则可能造成解析失败的错误异常
    *
    * @param dateStr 必须是 yyyy-MM-dd 格式的字符串
    * @return LocalDate
    */
   public static LocalDate parseYMD(String dateStr){}
   ```

### 项目规范

1. 代码目录结构

   基础层级目录

   ```
   src                               源码目录
   |-- common                            各个项目的通用类库
   |-- config                            项目的配置信息
   |-- handler                           全局处理器
   |-- interceptor                       全局拦截器
   |-- listener                          全局监听器
   |-- module                            各个业务
   |-- |--- employee                         员工模块
   |-- |--- role                             角色模块
   |-- |--- login                            登录模块
   |-- third                             三方服务，比如redis, oss，微信sdk等等
   |-- util                              全局工具类
   |-- Application.java                  启动类
   ```
   
2. common目录规范

   common 目录用于存放各个项目通用的项目，但是又可以依照项目进行特定的修改。

   ```
   src 源码目录
   |-- common 各个项目的通用类库
   |-- |--- anno          通用注解，比如权限，登录等等
   |-- |--- constant      通用常量，比如 ResponseCodeConst
   |-- |--- domain        全局的 javabean，比如 BaseEntity,PageParamDTO 等
   |-- |--- exception     可能用到的异常，如 BusinessException
   |-- |--- validator     适合各个项目的通用 validator，如 CheckEnum，CheckBigDecimal 等
   ```

3. config目录规范

   config 目录用于存放各个项目通用的项目，但是又可以依照项目进行特定的修改。

   ```
   src                               源码目录
   |-- config                            项目的所有配置信息
   |-- |--- MvcConfig                    mvc的相关配置，如interceptor,filter等
   |-- |--- DataSourceConfig             数据库连接池的配置
   |-- |--- MybatisConfig                mybatis的配置
   |-- |--- ....                         其他
   ```

4. module目录规范

   module 目录里写项目的各个业务，每个业务一个独立的顶级文件夹，在文件里进行 mvc 的相关划分。 其中，domain 包里存放 entity, dto, vo，bo 等 javabean 对象

   ```
   src
   |-- module                         所有业务模块(下面的模块只是举例)
   |-- |-- role                          角色模块
   |-- |-- |--RoleController.java              controller
   |-- |-- |--RoleConst.java                   role相关的常量
   |-- |-- |--RoleService.java                 service
   |-- |-- |--RoleDao.java                     dao
   |-- |-- |--domain                           domain
   |-- |-- |-- |-- RoleEntity.java                  表对应实体
   |-- |-- |-- |-- RoleDTO.java                     DTO(request、response)
   |-- |-- |-- |-- RoleVO.java                      VO(trans)
   |-- |-- employee                      员工模块
   |-- |-- login                         登录模块
   |-- |-- email                         邮件模块
   |-- |-- ....                          其他
   ```

5. domain包中的JavaBean规范

   1. `javabean`的整体要求：
      - 不能有任何的业务逻辑或者计算
      - 基本数据类型必须使用包装类型（Integer，Double，Boolean等）
      - 不允许添加任何默认值
      - 每个属性必须添加注释，必须使用多行注释
   2. 数据对象`XxxxEntity`，要求：、
      - 以 `Entity` 为结尾
      - Xxxx 与数据库表名保持一致
      - 类中字段要与数据库字段保持一致，不能缺失或者多余
      - 类中的每个字段添加注释，并与数据库注释保持一致
      - 不允许有组合
      - 项目内的日期和时间类型必须统一，建议使用 `java.util.Date，java.sql.Timestamp，java.time.LocalDateTime` 其中之一。create_time和update_time两个使用Timestamp，而其他的使用Date类型，是为了防止有时间戳无法到达的时间。
   3. 传输对象`XxxxDTO`，要求：
      - 不可以继承自 `Entity`
      - `DTO` 可以继承、组合其他 `DTO，VO，BO` 等对象
      - `DTO` 只能用于前端、RPC 的请求参数，以及返回前端，RPC的业务数据封装对象
      - 主要用于远程调用等需要大量传输对象的地方，比如我们有一个交易订单表，含有 25 个字段，那么其对应的 `PO` 就有 25 个属性，但我们的页面上只需要显示 5 个字段，因此没有必要把整个 `PO 对象`（持久层对象）传递给客户端，这时我们只需把仅有 5 个属性的 `DTO` 把结果传递给客户端即可，而且如果用这个对象来对应界面的显示对象，那此时它的身份就转为 `VO`。使用` DTO` 的好处有两个，一是能避免传递过多的无用数据，提高数据的传输速度；二是能隐藏后端的表结构。常见的用法是：将请求的数据或属性组装成一个 `RequestDTO`，再将响应的数据或属性组装成一个 `ResponseDTO`.
   4. 视图对象`XxxxVO`，要求：
      - 不可继承自 `Entity`
      - `VO` 可以继承、组合其他 `DTO，VO，BO` 等对象
      - `VO` 只能用于内部传输数据
      - `VO `也可以称为页面对象，如果称为页面对象的话，那么它所代表的将是整个页面展示层的对象，也可以由需要的业务对象进行组装而来

### MVC规范

1. 整体分层

   - controller层
   - service层
   - manager层
   - dao层

2. `controller`层规范

   - 只允许在method上添加`RequestMapping`注解，不允许加在class上（为了方便查找url）

   - 不推荐使用rest命名url，只能使用`get/post`方法，url命名规范如下：`业务模块/子模块/动作`

     例如：

     ```java
     GET  /department/get/{id}      查询某个部门详细信息
     POST /department/query         复杂查询
     POST /department/add           添加部门
     POST /department/update        更新部门
     GET  /department/delete/{id}   删除部门
     ```

   - controller负责协同和委派业务，充当路由的角色，每个方法必须保持简洁：

     - 不做任何业务逻辑处理
     - 不做任何的参数校验、业务校验，参数校验只允许使用`@Vaild`进行简单的校验
     - 不做任何的数据组合、拼装、赋值等操作

     例如：

     ```java
     @ApiOperation("添加部门 @author 哪吒")
     @PostMapping("/department/add")
     public ResponseDTO<String> addDepartment(@Valid @RequestBody DepartmentCreateDTO departmentCreateDTO) {
             return departmentService.addDepartment(departmentCreateDTO);
     }
     ```

   - 只能在 `controller` 层获取当前请求用户，并传递给 `service` 层。

     *因为获取当前请求用户是从 ThreadLocal 里获取取的，在 service、manager、dao 层极有可能是其他非 request 线程调用，会出现 null 的情况，尽量避免*

     ```java
     @ApiOperation("添加员工 @author yandanyang")
     @PostMapping("/employee/add")
     public ResponseDTO<String> addEmployee(@Valid @RequestBody EmployeeAddDTO employeeAddDTO) {
     		// 自己写工具类或者其他简洁的处理得到用户
             LoginTokenBO requestToken = SmartRequestTokenUtil.getRequestUser();
             return employeeService.addEmployee(employeeAddDTO, requestToken);
         }
     ```

3. `service`规范

   - 命名规范参考dao层，要体现业务逻辑

   - 谨慎处理 `@Transactional` 事务注解的使用，不要简单对 `service` 的方法添加个 `@Transactional` 注解就觉得万事大吉了。应当合并对数据库的操作，尽量减少添加了`@Transactional`方法内的业务逻辑。

   - `@Transactional` 注解内的 `rollbackFor` 值必须使用异常的基类 `Throwable.class`

     *对于@Transactional 注解，当 spring 遇到该注解时，会自动从数据库连接池中获取 connection，并开启事务然后绑定到 ThreadLocal 上，如果业务并没有进入到最终的 操作数据库环节，那么就没有必要获取连接并开启事务，应该直接将 connection 返回给数据库连接池，供其他使用*

   反例：

   ```java
   @Transactional(rollbackFor = Throwable.class)
   public ResponseDTO<String> upOrDown(Long departmentId, Long swapId) {
           // 验证 1
           DepartmentEntity departmentEntity = departmentDao.selectById(departmentId);
           if (departmentEntity == null) {
               return ResponseDTO.wrap(DepartmentResponseCodeConst.NOT_EXISTS);
           }
           // 验证 2
           DepartmentEntity swapEntity = departmentDao.selectById(swapId);
           if (swapEntity == null) {
               return ResponseDTO.wrap(DepartmentResponseCodeConst.NOT_EXISTS);
           }
           // 验证 3
           Long count = employeeDao.countByDepartmentId(departmentId)
           if (count != null && count > 0) {
               return ResponseDTO.wrap(DepartmentResponseCodeConst.EXIST_EMPLOYEE);
           }
           // 操作数据库 4
           Long departmentSort = departmentEntity.getSort();
           departmentEntity.setSort(swapEntity.getSort());
           departmentDao.updateById(departmentEntity);
           swapEntity.setSort(departmentSort);
           departmentDao.updateById(swapEntity);
           return ResponseDTO.succ();
   }
   ```

   正例：

   ```java
    DepartmentService.java
   
       public ResponseDTO<String> upOrDown(Long departmentId, Long swapId) {
           DepartmentEntity departmentEntity = departmentDao.selectById(departmentId);
           if (departmentEntity == null) {
               return ResponseDTO.wrap(DepartmentResponseCodeConst.NOT_EXISTS);
           }
           DepartmentEntity swapEntity = departmentDao.selectById(swapId);
           if (swapEntity == null) {
               return ResponseDTO.wrap(DepartmentResponseCodeConst.NOT_EXISTS);
           }
           Long count = employeeDao.countByDepartmentId(departmentId)
           if (count != null && count > 0) {
               return ResponseDTO.wrap(DepartmentResponseCodeConst.EXIST_EMPLOYEE);
           }
           departmentManager.upOrDown(departmentSort,swapEntity);
           return ResponseDTO.succ();
       }
   
   
       DepartmentManager.java
   
       @Transactional(rollbackFor = Throwable.class)
       public void upOrDown(DepartmentEntity departmentEntity ,DepartmentEntity swapEntity){
           Long departmentSort = departmentEntity.getSort();
           departmentEntity.setSort(swapEntity.getSort());
           departmentDao.updateById(departmentEntity);
           swapEntity.setSort(departmentSort);
           departmentDao.updateById(swapEntity);
       }
   
   ```

   *将数据在 service 层准备好，然后传递给 manager 层，由 manager 层添加@Transactional 进行数据库操作。需要注意的是：注解 `@Transactional` 事务在类的内部方法调用是不会生效的（解决方式：将方法放入另一个类，如manager层，或者在启动类添加`@EnableAspectJAutoProxy(exposeProxy = true)`，方法内使用`AopContext.currentProxy()`获得代理类，使用事务）*

   ```java
   SpringBootApplication.java
   
   @EnableAspectJAutoProxy(exposeProxy = true)
   @SpringBootApplication
   public class SpringBootApplication {}
   
   OrderService.java
   
   public void createOrder(OrderCreateDTO createDTO){
       OrderService orderService = (OrderService)AopContext.currentProxy();
       orderService.saveData(createDTO);
   }
   ```

4. `manager`规范

   - 对第三方平台封装的层，预处理返回结果及转化异常信息；
   - 对 Service 层通用能力的下沉，如缓存方案、中间件通用处理；
   - 与 DAO 层交互，对多个 DAO 的组合复用。

5. `dao`规范

   - dao方法命名规范（JPA有自己的规范）
     - 获取单个对象的方法用 `get` 做前缀。
     - 获取多个对象的方法用 `list` 做前缀。
     - 获取统计值的方法用 `count` 做前缀。
     - 插入的方法用 `save/insert` 做前缀。(推荐save)
     - 删除的方法用 `remove/delete` 做前缀。(推荐delete)
     - 修改的方法用 `update` 做前缀。

### boolean类型的属性命名规范

> 类中布尔类型的变量，都不要加is，否则部分框架解析会引起序列化错误。反例：定义为基本数据类型 Boolean isDeleted；的属性，它的方法也是 isDeleted()，RPC在反向解析的时候，“以为”对应的属性名称是 deleted，导致属性获取不到，进而抛出异常。

`boolean` 类型的类属性和数据表字段都统一使用 `flag` 结尾。虽然使用 `isDeleted，is_deleted` 从字面语义上更直观，但是比起可能出现的潜在错误，这点牺牲还是值得的。

正例：

```text
deletedFlag，deleted_flag，onlineFlag，online_flag(优先使用小驼峰)
```

## Restful接口规范

url格式为 /业务模块/子模块/动作

只使用get和post（偶尔可能加入put）

```java
GET  /department/get/{id}      查询某个部门详细信息
POST /department/query         复杂查询
POST /department/add           添加部门
POST /department/update        更新部门
GET  /department/delete/{id}   删除部门
```



> 除文件传输流外，其他数据类型的接口返回体均采用如下形式

```json
{
    "success": boolean,
    "code": int,
    "msg": string,
    "data": Object{
    	"page": integer,
    	"size": integer,
    	"total": integer,
    	"totalPage": integer,
    	"list"：array or null
		}
}
```

### success

代表有没有完整完成整个接口的正常流程，完成则是true，有任何错误都是false

### code

代表服务状态码，自定义，和前端约定好，用于前端进行判断和提示等

| code | msg          |
| ---- | ------------ |
| 0    | 操作成功！   |
| 1001 | 用户名不存在 |
| 1002 | ……           |

### msg

代表前端要展示的信息，比如用户名不正确等，与code应该是一对一或一对多

如果msg和之前定义的枚举不一致，则显示返回值，否则显示枚举值

### data

数据流集合，没有则为`null`

#### 分页的情况

分页的前端传参在body，如下形式

**注意，<font color=red>page</font>必传，size如果不传则为默认20**

```json
{
    "page": integer,
    "size": integer or null,
    "others": 其他参数例如sort等
}
```

返回体形式如下

    	"page": 当前页数,
    	"size": 每页数量,
    	"total": 总记录数,
    	"totalPage": 总页数,
    	"list"：数据

## Commit规范

每次提交，Commit message 都包括三个部分：Header，Body 和 Footer。其中，Header 是必需的，Body 和 Footer 可以省略,不管是哪一个部分，任何一行都不得超过72个字符（或100个字符）。这是为了避免自动换行影响美观。

### Commit messages的基本语法

```shell
<type>: <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

Type表示提交类别，Subject表示标题行， Body表示主体描述内容。
Type的类别说明：

- feat：添加新特性
- fix：修复bug
- docs：仅仅修改了文档
- style：仅仅修改了空格，缩进等，不改变代码逻辑
- refactor：代码重构，没有新功能增加或者bug的修复，仅仅只是重构
- perf：增加代码进行性能测试
- test：增加测试用例
- chore：改变构建流程、增加依赖库、工具等

### Commit messages格式要求

```中文
# 标题行：50个字符以内，描述主要变更内容
#
# 主体内容：更详细的说明文本，建议72个字符以内。 需要描述的信息包括:
#
# * 为什么这个变更是必须的? 它可能是用来修复一个bug，增加一个feature，提升性能、可靠性、稳定性等等
# * 他如何解决这个问题? 具体描述解决问题的步骤
# * 是否存在副作用、风险? 
#
# 如果需要的化可以添加一个链接到issue地址或者其它文档
```

### Commit messages书写建议

Header部分只有一行，包括三个字段：type（必需）、scope（可选）和subject（必需）

> a).type:用于说明 commit 的类别，只允许使用下面7个标识。如果type为feat和fix，则该 commit 将肯定出现在 Change log 之中。其他情况（docs、chore、sty le、refactor、test）视情况决定，要不要放入 Change log，建议是不要。

```
 - feat：新功能（feature）
 - fix：修补bug
 - fdocs：文档（documentation）
 - style： 格式（不影响代码运行的变动）
 - refactor：重构（即不是新增功能，也不是修改bug的代码变动）
 - test：增加测试
 - chore：构建过程或辅助工具的变动
```

> b).scope:用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。
>
> (可以不加)

> c).subject:是 commit 目的的简短描述，不超过50个字符。有两个注意点。(1).使用第一人称现在时，比如使用改变而不是将或使用。(2).应该说明代码变动的动机，以及与以前行为的对比。

```
*** 以动词开头，使用第一人称现在时，比如change，而不是changed或changes
*** 第一个字母小写
*** 结尾不加句号（.）
```

> d).Body:是对本次 commit 的详细描述，可以分成多行。

> e).Footer:用于关闭issue 如closes #234，#345

#### Revert

还有一种特殊情况，如果当前 commit 用于撤销以前的 commit，则必须以revert:开头，后面跟着被撤销 Commit 的Header。

```
revert: feat(pencil): add 'graphiteWidth' option

This reverts commit 667ecc1654a317a13331b17617d973392f415f02.
```

Body部分的格式是固定的，必须写成This reverts commit <hash>.，其中的hash是被撤销 commit 的 SHA 标识符。

如果当前 commit 与被撤销的 commit，在同一个发布（release）里面，那么它们都不会出现在 Change log 里面。如果两者在不同的发布，那么当前 commit，会出现在 Change log 的Reverts小标题下面。

## git分支规范

### 分支介绍

| 分支类型 | 分支前缀   | 简介                                                         |
| -------- | ---------- | ------------------------------------------------------------ |
| 主分支   | master     | 生产环境分支。<font color=red>固定分支</font>                |
| 预发分支 | pre        | 预发环境分支。<font color=red>固定分支</font>                |
| 开发分支 | dev        | 测试环境分支。<font color=red>固定分支</font>                |
| 功能分支 | feature/*  | 作为新功能开发分支。                                         |
| 补丁分支 | hotfix/*   | 作为生产环境问题修复分支。                                   |
| 支持分支 | support/*  | 作为代码优化、重构分支。                                     |
| 冲突分支 | conflict/* | 作为解决合并冲突使用的分支，合并冲突解决完毕后即删除。<font color=red>自定义类型分支</font> |

> 除固定分支外，其他分支合并到master的顺序
>
> - 合并到 `dev` ：问题修复完成，等待测试。
> - 合并到 `pre` ：问题修复测试通过，预发环境测试。
> - 合并到 `master` ：预发环境测试通过，发布。
