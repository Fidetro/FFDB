# FFDB
### 为什么会有FFDB？
1. 因为作者很懒，直接用FMDB代码会很散，而且并不能像使用CoreData能面向对象管理；
2. 在项目中经常会遇到不得不使用数据库去存储数据的情况；
3. 主流的移动端数据库，用过的只有FMDB，CoreData，CoreData在使用的时候觉得要写太多代码了，后来放弃了，只用FMDB的话，没有OOP的感觉，所以有了FFDB。

### CoreData、Realm和对FMDB封装后的FFDB对比
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

### 适合在什么地方使用？
1. 数据量大，NSUserDefault和plist都不能满足的时候；
2. 对基础数据库语句不太懂的同学；

### 优势

1. 不需要对数据库进行很复杂的操作；
2. 通过runtime实现，不需要接触到sqlite语句就能满足增删改查；

### 怎么使用？
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

### 补充
1. 目前FFDB只是提供了简单的增删改查接口，如果要使用目前接口没办法满足的功能，可以通过获取FMDatabase和表名通过原来的FMDB语句进行扩充；
2. 在性能上没有考虑，如果有什么好的建议，可以Issue我
```
获取FMDatabase对象
[Class getDatabase];
获取类在FMDB对应的表名
[Class getTableName];
```
