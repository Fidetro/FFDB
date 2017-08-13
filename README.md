# FFDB

1.x的文档请移步
[这里](https://github.com/Fidetro/FFDB/blob/master/1.x_README.md)

- [为什么会有FFDB？](#为什么会有FFDB？)
- [CoreData、Realm和对FMDB封装后的FFDB对比](#CoreData、Realm和对FMDB封装后的FFDB对比)
- [适合在什么地方使用以及优势](#适合在什么地方使用以及优势)
- [怎么使用？如何集成？(请直接戳我)](#怎么使用？如何集成？)
- [2.x和3.x的版本有什么不同？](#2.x和3.x的版本有什么不同？)
- [补充](#补充)
- [Pod版本更新说明](#Pod版本更新说明)
-[UML类图](#UML类图)

<h2 id="为什么会有FFDB？">为什么会有FFDB？</h2>

1. 直接用FMDB代码并不优雅而且十分繁琐，而且并不能像使用CoreData能面向对象管理;
2. 在项目中经常会遇到不得不使用数据库去存储数据的情况；
3. 主流的移动端数据库，用过的只有FMDB，CoreData，CoreData在使用的时候觉得要写太多代码了，后来放弃了，只用FMDB的话，没有使用ORM的方便，所以有了FFDB。
4. 解释下FFDB的名字含义，是因为了纪念可能再也见不到的芳芳，不能一起工作真是太可惜了

<h2 id="CoreData、Realm和对FMDB封装后的FFDB对比">CoreData、Realm和对FMDB封装后的FFDB对比</h2>

下面这部分代码出自于Realm的文档

[从这里你可以找到](https://realm.io/news/migrating-from-core-data-to-realm)

```
CoreData插入对象
//Create a new Dog
Dog *newDog = [NSEntityDescription insertNewObjectForEntityForName:@"Dog" inManagedObjectContext:myContext];
newDog.name = @"McGruff";

//Save the new Dog object to disk
NSError *saveError = nil;
[newDog.managedObjectContext save:&saveError];

//Rename the Dog
newDog.name = @"Pluto";
[newDog.managedObjectContext save:&saveError];
```

```
Realm插入对象
//Create the dog object
Dog *newDog = [[Dog alloc] init];
newDog.name = @"McGruff";

//Save the new Dog object to disk (Using a block for the transaction)
RLMRealm *defaultRealm = [RLMRealm defaultRealm];
[defaultRealm transactionWithBlock:^{
[defaultRealm addObject:newDog];
}];

//Rename the dog (Using open/close methods for the transaction)
[defaultRealm beginWriteTransaction];
newDog.name = @"Pluto";
[defaultRealm commitWriteTransaction];
```
```

FFDB插入对象
Dog *newDog = [[Dog alloc] init];
newDog.name = @"McGruff";
[newDog insertObject];
//重命名狗，更新对象
newDog.name = @"Pluto";
[newDog updateObject];
```
```
CoreData查询
NSManagedObjectContext *context = self.managedObjectContext;

//A fetch request to get all dogs younger than 5 years old, in alphabetical order
NSEntityDescription *entity = [NSEntityDescription
entityForName:@"Dog" inManagedObjectContext:context];

NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 5"];

NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

NSFetchRequest *request = [[NSFetchRequest alloc] init];
request.entity = entity;
request.predicate = predicate;
request.sortDescriptors = @[sortDescriptor];

NSError *error;
NSArray *dogs = [moc executeFetchRequest:request error:&error];
```
```
Realm查询对象
RLMResults *dogs = [[Dog objectsWhere:@"age < 5"] sortedResultsUsingProperty:@"name" ascending:YES];
```

```
FFDB查询对象
NSArray<Dog *> *dogs = [Dog selectFromClassPredicateWithFormat:@"where age < 5 order by name"];
```

> 类相当于一张表，对象即数据，这句话贯穿整个设计的思路



<h2 id="适合在什么地方使用以及优势">适合在什么地方使用以及优势？</h2>

1. 数据量大，NSUserDefault和plist都不能满足的时候；
2. 对基础数据库语句不太懂的同学；
3. 不需要对数据库进行很复杂的操作；
4. 通过runtime实现，~~不需要接触到sqlite语句~~(还是要懂一点点的)就能满足增删改查；

<h2 id="怎么使用？如何集成？">怎么使用？如何集成？</h2>

[CocoaPod这里](https://cocoapods.org/pods/FFDB)

pod 'FFDB’,’~>3.x’
pod search FFDB如果没有找到，pod setup之后就ok了

如果不使用CocoaPod，请导入`FMDB`，并且在target的Linked Frameworks and Libraries导入
libsqlite3.0.tbd

![image](https://github.com/Fidetro/FFDB/blob/master/src/1.png)

同时把目录中的这些文件拉到工程中

![image](https://github.com/Fidetro/FFDB/blob/master/src/4.png)

建立好要创建的类继承`FFDataBaseModel`，声明属性即可，
如一个`Person`表里，有人名，年龄字段。

```
@interface Person : FFDataBaseModel
/** 人名 **/
@property(nonatomic,copy) NSString *name;
/** 年龄 **/
@property(nonatomic,copy) NSString *age;
插入:
Person *person = [[Person alloc]init];//创建对象
person.name = @"Fidetro";//设置属性
[person insertObject];//插入数据

查询:
[Person selectFromClassAllObject];//等同于查询Person表中所有的对象
[Person selectFromClassPredicateWithFormat:@"where age == '15' and name == 'Fidetro'"]//等同于查询年龄是15和名字叫Fidetro的数据
更新：
NSArray *personArray = [Person selectFromClassPredicateWithFormat:@"where name = 'fidetro' and age = '21'"];//先查询到要更新的数据
Person *person = [personArray lastObject];
person.age = @"24";
[person updateObject];

删除:
NSArray *personArray = [Person selectFromClassPredicateWithFormat:@"where name = 'fidetro' and age = '21'"];//先查询到要更新的数据
Person *person = [personArray lastObject];
[person deleteObject];

```

<h2 id="2.x和3.x的版本有什么不同？">2.x和3.x的版本有什么不同？</h2>
1. 这次的改动在接口层没有过多的改动，在实现上，把原来的db操作，移到了`FFDBManager`,`FFDataBaseModel`不再直接能获取到db，同时也因为这个原因，之前生成SQL语句的`FFDataBaseModel+sqlite`,也进行了改动，现在由`NSString+FFDBSQLStatement`生成SQL语句，`FFDataBaseModel+sqlite`只负责模型自身属性生成的字符串的部分，这样做之后，会在后面的版本新增联表查询等的一些操作


<h2 id="补充">补充</h2>
<br>1. 所有字段都是默认是TEXT，在后面的版本会增加自定义字段类型这个功能;
<br>2. 所有继承FFDataBaseModel的对象，在插入数据库后，都会自带一个primaryID作为唯一标识，同时这是一个自增的字段;
<br>3. 目前FFDB只是提供了简单的增删改查接口，如果要使用目前接口没办法满足的功能，可以通过以下几个方法进行扩充的操作;

```
获取FMDatabase对象
[FFDBManager database];
获取类在FMDB对应的表名
[Class tableName];

需要自定义表名，需要在子类重写 + (NSString *)tableName;
+ (NSString *)tableName
{
   return @"CustomTableName";
}

```
通过获取了这两个，可以自己结合FMDB原有的方法进行操作。
<br>4. FFDB支持与swift 3混编。

<h2 id="Pod版本更新说明">Pod版本更新说明</h2>
<h2 id="UML类图">UML类图</h2>


![image](https://github.com/Fidetro/FFDB/blob/master/src/5.png)
