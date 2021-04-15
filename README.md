# F3_Tree

*A Tree helper for the PHP Fat-Free framework (F3) implementing the modified preorder tree traversal algorithm*

[![Latest Stable Version](https://poser.pugx.org/dryas/f3-tree/v/stable)](https://packagist.org/packages/dryas/f3-tree) [![Total Downloads](https://poser.pugx.org/dryas/f3-tree/downloads)](https://packagist.org/packages/dryas/f3-tree) [![License](https://poser.pugx.org/dryas/f3-tree/license)](https://packagist.org/packages/dryas/f3-tree)

## What is Modified Preorder Tree Traversal

MPTT is a fast algorithm for storing hierarchical data (like categories and their subcategories) in a relational database. This is a problem that most of us have had to deal with, and for which we've used an [adjacency list](http://mikehillyer.com/articles/managing-hierarchical-data-in-mysql/), where each item in the table contains a pointer to its parent and where performance will naturally degrade with each level added as more queries need to be run in order to fetch a subtree of records.

The aim of the modified preorder tree traversal algorithm is to make retrieval operations very efficient. With it you can fetch an arbitrary subtree from the database using just two queries. The first one is for fetching details for the root node of the subtree, while the second one is for fetching all the children and grandchildren of the root node.

The tradeoff for this efficiency is that updating, deleting and inserting records is more expensive, as there's some extra work required to keep the tree structure in a good state at all times. Also, the modified preorder tree traversal approach is less intuitive than the adjacency list approach because of its algorithmic flavour.

For more information about the modified preorder tree traversal method, read this excellent article called [Storing Hierarchical Data in a Database](http://blogs.sitepoint.com/hierarchical-data-database-2/).

## What is F3_Tree

**F3\_Tree** is a tree helper plugin for the [Fat-Free Framework](http://github.com/bcosca/fatfree) that provides an implementation of the modified preorder tree traversal algorithm making it easy to implement the MPTT algorithm in your applications.

It provides methods for adding nodes anywhere in the tree, deleting nodes, moving and copying nodes around the tree and methods for retrieving various information about the nodes.

F3\_Tree is based on the fantastic [Zebra_Mptt](https://github.com/stefangabos/Zebra_Mptt) library by [Stefan Gabos](https://github.com/stefangabos) and uses [table locks](http://dev.mysql.com/doc/refman/5.0/en/lock-tables.html) making sure that database integrity is always preserved and that concurrent MySQL sessions don't compromise data integrity. Also, F3_Tree uses a caching mechanism which has as result the fact that regardless of the type, or the number of retrieval operations, **the database is read only once per script execution!**

Instead of using the Mysqli extension for database access like the original Zebra_Mptt library is using, the F3_Tree library uses the PDO extension like it is used in the Fat-Free Framework.

## Features

- provides methods for adding nodes anywhere in the tree, deleting nodes, moving and copying nodes around the tree and methods for retrieving various information about the nodes
- uses a caching mechanism which has as result the fact that regardless of the type, or the number of retrieval operations, **the database is read only once per script execution**
- uses [table locks](http://dev.mysql.com/doc/refman/5.0/en/lock-tables.html) making sure that database integrity is always preserved and that concurrent MySQL sessions don't compromise data integrity
- code is heavily commented and generates no warnings/errors/notices when PHP's error reporting level is set to [E_ALL](https://web.archive.org/web/20160226192832/http://www.php.net/manual/en/function.error-reporting.php)

## Requirements

PHP 5.0.0+, MySQL 4.1.22+, Fat-Free Framework 3.7.3+

Attention: As PDO offers connectors to different database systems, it is likely that the library also works with other database systems than MySQL (which I'm mostly using). I'm always glad if you want to offer your support on making the library more compatible with different database systems by doing a pull request with your changes. Thanks!

## Installation

You can install F3_Tree via [Composer](https://packagist.org/packages/dryas/f3_tree)

```bash
# get the latest stable release
composer require dryas/f3_tree

# get the latest commit
composer require dryas/f3_tree:dev-master
```

Or you can install it manually by downloading the latest version, unpacking it, and then including it in your project

```php
require_once 'path/to/f3_tree.php';
```

## Install MySQL table

Notice a directory called *install* containing a file named *f3_tree.sql*. This file contains the SQL code that will create the table used by the class to store its data. Import or execute the SQL code using your preferred MySQL manager (like phpMyAdmin) into a database of your choice.

## How to use

```php
// If you don't use composers autoloader feature, you need to include the F3_Tree class
require 'path/to/f3_tree.php';

// instantiate a new object
$f3t = new F3_Tree();

// populate the table

// add 'Food' as a topmost node
$food = $f3t->add(0, 'Food');

// 'Fruit' and 'Meat' are direct descendants of 'Food'
$fruit = $f3t->add($food, 'Fruit');
$meat = $f3t->add($food, 'Meat');

// 'Red' and 'Yellow' are direct descendants of 'Fruit'
$red = $f3t->add($fruit, 'Red');
$yellow = $f3t->add($fruit, 'Yellow');

// add a fruit of each color
$cherry = $f3t->add($red, 'Cherry');
$banana = $f3t->add($yellow, 'Banana');

// add two kinds of meat
$f3t->add($meat, 'Beef');
$f3t->add($meat, 'Pork');

// move 'Banana' to 'Meat'
$f3t->move($banana, $meat);

// get a flat array of descendants of 'Meat'
$f3t->get_children($meat);

// get a multidimensional array (a tree) of all the data in the database
$f3t->get_tree();
```
