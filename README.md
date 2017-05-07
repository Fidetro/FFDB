# FFDB
- [为什么会有FFDB？](#为什么会有FFDB？)
- [CoreData、Realm和对FMDB封装后的FFDB对比](#CoreData、Realm和对FMDB封装后的FFDB对比)
- [适合在什么地方使用以及优势](#适合在什么地方使用以及优势)
- [怎么使用？](#怎么使用？)
- [补充](#补充)


## 支持使用CocoaPod
pod 'FFDB’,’~>1.0.7’
pod search FFDB如果没有找到，pod setup之后就ok了

如果不使用CocoaPod，请导入FMDB，并且在target的Linked Frameworks and Libraries导入
libsqlite3.0.tbd

![image](https://github.com/Fidetro/FFDB/blob/master/src/1.png)

同时把目录中的这些文件拉到工程中

![image](https://github.com/Fidetro/FFDB/blob/master/src/2.png)

<h2 id="为什么会有FFDB？">为什么会有FFDB？</h2>

1. 因为作者很懒，直接用FMDB代码会很散，而且并不能像使用CoreData能面向对象管理；
2. 在项目中经常会遇到不得不使用数据库去存储数据的情况；
3. 主流的移动端数据库，用过的只有FMDB，CoreData，CoreData在使用的时候觉得要写太多代码了，后来放弃了，只用FMDB的话，没有OOP的感觉，所以有了FFDB。
4. 最后解释下FFDB的名字含义，是因为了纪念可能再也见不到的芳芳，不能一起工作真是太可惜了





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
NSArray<Dog *> *dogs = [Dog selectObjectPredicateWithFormat:@"where age < 5 order by name"];
```

> 类相当于一张表，对象即数据，这句话贯穿整个设计的思路



<h2 id="适合在什么地方使用以及优势">适合在什么地方使用以及优势？</h2>

1. 数据量大，NSUserDefault和plist都不能满足的时候；
2. 对基础数据库语句不太懂的同学；
3. 不需要对数据库进行很复杂的操作；
4. 通过runtime实现，不需要接触到sqlite语句就能满足增删改查；


<h2 id="怎么使用？">怎么使用？</h2>

建立好要创建的类继承FIDDataBaseModel，声明属性，即可
```
@interface Person : FIDDataBaseModel
/** 人名 **/
@property(nonatomic,copy) NSString *name;
/** 年龄 **/
@property(nonatomic,copy) NSString *age;
插入:
Person *person = [[Person alloc]init];//创建对象
person.name = @"Fidetro";//设置属性
[person insertObject];//插入数据

查询:
[Person selectAllObject];//等同于查询Person表中所有的对象

更新：
NSArray *personArray = [Person selectObjectPredicateWithFormat:@"where name = 'fidetro' and age = '21'"];//先查询到要更新的数据
Person *person = [personArray lastObject];
person.age = @"24";
[person updateObject];

删除:
NSArray *personArray = [Person selectObjectPredicateWithFormat:@"where name = 'fidetro' and age = '21'"];//先查询到要更新的数据
Person *person = [personArray lastObject];
[person deleteObject];

```


<h2 id="补充">补充</h2>

1. 目前FFDB只是提供了简单的增删改查接口，如果要使用目前接口没办法满足的功能，可以通过获取FMDatabase和表名通过原来的FMDB语句进行扩充；
2. 在性能上没有考虑，如果有什么好的建议，可以Issue我
```
获取FMDatabase对象
[Class getDatabase];
获取类在FMDB对应的表名
[Class getTableName];
```

GitHub有个比较简单的使用Demo，有问题可以通过Issue我

> [GitHub地址](https://github.com/Fidetro/FFDB)
