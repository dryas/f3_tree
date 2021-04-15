CREATE TABLE IF NOT EXISTS `f3tree` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) NOT NULL default '',
  `lft_id` int(11) NOT NULL default '0',
  `rgt_id` int(11) NOT NULL default '0',
  `parent_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
