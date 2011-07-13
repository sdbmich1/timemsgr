-- MySQL dump 10.13  Distrib 5.5.9, for Win32 (x86)
--
-- Host: localhost    Database: kits_development
-- ------------------------------------------------------
-- Server version	5.5.9

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `reward_credits`
--

DROP TABLE IF EXISTS `reward_credits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reward_credits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `model_name` varchar(255) DEFAULT NULL,
  `credits` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reward_credits`
--

LOCK TABLES `reward_credits` WRITE;
/*!40000 ALTER TABLE `reward_credits` DISABLE KEYS */;
INSERT INTO `reward_credits` VALUES (1,'event_name','Event',100,NULL,NULL),(2,'title','Event',50,NULL,NULL),(3,'event_type','Event',50,NULL,NULL),(4,'start_date','Event',100,NULL,NULL),(5,'end_date','Event',50,NULL,NULL),(6,'start_time','Event',100,NULL,NULL),(7,'end_time','Event',100,NULL,NULL),(8,'location','Event',100,NULL,NULL),(9,'address','Event',250,NULL,NULL),(10,'city','Event',100,NULL,NULL),(11,'state','Event',100,NULL,NULL),(12,'country','Event',100,NULL,NULL),(13,'other_details','Event',200,NULL,NULL),(14,'overview','Event',200,NULL,NULL),(15,'description','Event',250,NULL,NULL),(16,'family_flg','Event',150,NULL,NULL),(17,'friends_flg','Event',150,NULL,NULL),(18,'world_flg','Event',150,NULL,NULL),(19,'email','Profile',100,NULL,NULL),(20,'first_name','Profile',50,NULL,NULL),(21,'middle_name','Profile',50,NULL,NULL),(22,'last_name','Profile',50,NULL,NULL),(23,'time_zone','Profile',50,NULL,NULL),(24,'birth_date','Profile',200,NULL,NULL),(25,'occupation','Profile',200,NULL,NULL),(26,'city','Profile',100,NULL,NULL),(27,'major_city','Profile',150,NULL,NULL),(28,'address','Profile',150,NULL,NULL),(29,'state','Profile',50,NULL,NULL),(30,'postalcode','Profile',100,NULL,NULL),(31,'country','Profile',50,NULL,NULL),(32,'company','Profile',150,NULL,NULL),(33,'job_title','Profile',100,NULL,NULL),(34,'home_phone','Profile',150,NULL,NULL),(35,'cell_phone','Profile',200,NULL,NULL),(36,'wireless_provider','Profile',250,NULL,NULL),(37,'work_phone','Profile',100,NULL,NULL),(38,'gender','Profile',100,NULL,NULL),(39,'marital_status','Profile',150,NULL,NULL),(40,'education','Profile',150,NULL,NULL),(41,'nationality','Profile',150,NULL,NULL),(42,'ethnicity','Profile',150,NULL,NULL),(43,'income','Profile',150,NULL,NULL),(44,'skill','Profile',150,NULL,NULL),(45,'hobby','Profile',150,NULL,NULL),(46,'interest_ids','Profile',150,NULL,NULL),(47,'name','Organization',100,NULL,NULL),(48,'interest_id','Interest',150,NULL,NULL);
/*!40000 ALTER TABLE `reward_credits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_credits`
--

DROP TABLE IF EXISTS `user_credits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_credits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `context` varchar(255) DEFAULT NULL,
  `credits` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_credits_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_credits`
--

LOCK TABLES `user_credits` WRITE;
/*!40000 ALTER TABLE `user_credits` DISABLE KEYS */;
INSERT INTO `user_credits` VALUES (1,NULL,NULL,'Profile',100,'2011-07-10 04:28:04','2011-07-10 04:28:04'),(2,NULL,NULL,'Profile',300,'2011-07-10 04:30:41','2011-07-10 04:30:41'),(3,231,NULL,'Profile',500,'2011-07-10 14:48:02','2011-07-10 14:48:02'),(4,232,NULL,'Profile',500,'2011-07-11 01:52:09','2011-07-11 01:52:09'),(5,232,NULL,'Profile',0,'2011-07-11 01:52:10','2011-07-11 01:52:10'),(6,232,NULL,'Profile',0,'2011-07-11 02:04:44','2011-07-11 02:04:44'),(7,231,NULL,'Profile',150,'2011-07-11 02:16:36','2011-07-11 02:16:36'),(8,232,NULL,'Profile',0,'2011-07-11 02:32:24','2011-07-11 02:32:24'),(9,232,NULL,'Profile',0,'2011-07-11 07:17:19','2011-07-11 07:17:19'),(10,232,NULL,'Profile',0,'2011-07-11 07:25:50','2011-07-11 07:25:50'),(11,54,NULL,'Profile',100,'2011-07-11 18:09:43','2011-07-11 18:09:43'),(12,55,NULL,'Profile',100,'2011-07-11 18:09:43','2011-07-11 18:09:43'),(13,232,NULL,'Profile',0,'2011-07-11 18:09:43','2011-07-11 18:09:43'),(14,232,NULL,'Profile',0,'2011-07-11 18:11:18','2011-07-11 18:11:18'),(15,233,NULL,'Profile',500,'2011-07-11 20:20:48','2011-07-11 20:20:48'),(16,233,NULL,'Profile',0,'2011-07-11 20:20:50','2011-07-11 20:20:50'),(17,233,NULL,'Profile',0,'2011-07-11 22:10:01','2011-07-11 22:10:01'),(18,233,NULL,'Profile',0,'2011-07-11 23:32:11','2011-07-11 23:32:11'),(19,233,NULL,'Profile',0,'2011-07-12 00:13:43','2011-07-12 00:13:43'),(20,233,NULL,'Profile',0,'2011-07-12 00:18:01','2011-07-12 00:18:01'),(21,233,NULL,'Profile',0,'2011-07-12 00:29:54','2011-07-12 00:29:54'),(22,56,NULL,'Profile',100,'2011-07-12 00:58:06','2011-07-12 00:58:06'),(23,233,NULL,'Profile',0,'2011-07-12 00:58:06','2011-07-12 00:58:06'),(24,233,NULL,'Profile',0,'2011-07-12 00:58:42','2011-07-12 00:58:42'),(25,234,NULL,'Profile',500,'2011-07-12 01:19:51','2011-07-12 01:19:51'),(26,234,NULL,'Profile',0,'2011-07-12 01:19:52','2011-07-12 01:19:52'),(27,234,NULL,'Profile',0,'2011-07-12 01:26:01','2011-07-12 01:26:01'),(28,234,NULL,'Affiliations',100,'2011-07-12 02:38:29','2011-07-12 02:38:29'),(29,234,NULL,'Affiliations',100,'2011-07-12 02:38:29','2011-07-12 02:38:29'),(30,235,NULL,'Profile',500,'2011-07-12 02:44:05','2011-07-12 02:44:05'),(31,235,NULL,'Profile',0,'2011-07-12 02:44:06','2011-07-12 02:44:06'),(33,235,NULL,'Affiliations',100,'2011-07-12 03:54:45','2011-07-12 03:54:45'),(34,235,NULL,'Affiliations',100,'2011-07-12 03:54:45','2011-07-12 03:54:45'),(35,235,NULL,'Affiliations',100,'2011-07-12 03:56:33','2011-07-12 03:56:33'),(36,234,NULL,'Profile',250,'2011-07-12 05:21:47','2011-07-12 05:21:47'),(37,239,NULL,'Profile',1,'2011-07-12 05:57:56','2011-07-12 05:57:56'),(38,239,NULL,'Profile',1,'2011-07-12 05:57:57','2011-07-12 05:57:57'),(39,239,NULL,'Affiliations',1,'2011-07-12 06:58:55','2011-07-12 06:58:55'),(40,239,NULL,'Affiliations',1,'2011-07-12 06:58:55','2011-07-12 06:58:55'),(41,239,NULL,'Affiliations',1,'2011-07-12 06:58:55','2011-07-12 06:58:55'),(42,240,NULL,'Profile',1,'2011-07-12 07:05:15','2011-07-12 07:05:15'),(43,240,NULL,'Affiliations',1,'2011-07-12 07:16:37','2011-07-12 07:16:37'),(44,241,NULL,'Profile',1,'2011-07-12 07:23:43','2011-07-12 07:23:43'),(45,241,NULL,'Interests',1,'2011-07-12 07:27:05','2011-07-12 07:27:05'),(46,241,NULL,'Affiliations',1,'2011-07-12 07:58:18','2011-07-12 07:58:18'),(47,241,NULL,'Affiliations',1,'2011-07-12 07:58:18','2011-07-12 07:58:18'),(48,239,NULL,'Test',1,'2011-07-12 08:09:07','2011-07-12 08:09:07'),(49,239,NULL,'Test2',500,'2011-07-12 08:10:56','2011-07-12 08:10:56'),(50,239,NULL,'Test3',500,'2011-07-12 08:17:22','2011-07-12 08:17:22'),(51,239,NULL,'Test4',500,'2011-07-12 08:17:51','2011-07-12 08:17:51'),(52,242,NULL,'Profile',1,'2011-07-12 08:19:41','2011-07-12 08:19:41'),(53,242,NULL,'Interests',1950,'2011-07-12 08:23:33','2011-07-12 08:23:33'),(54,242,NULL,'Affiliations',100,'2011-07-12 08:24:27','2011-07-12 08:24:27'),(55,243,NULL,'Profile',500,'2011-07-12 16:57:51','2011-07-12 16:57:51'),(56,243,NULL,'Interests',2700,'2011-07-12 16:59:42','2011-07-12 16:59:42'),(57,243,NULL,'Affiliations',100,'2011-07-12 17:01:00','2011-07-12 17:01:00'),(58,243,NULL,'Affiliations',100,'2011-07-12 17:01:00','2011-07-12 17:01:00'),(59,243,NULL,'Event',1850,'2011-07-12 17:27:59','2011-07-12 17:27:59'),(60,243,NULL,'Event',1850,'2011-07-12 17:40:41','2011-07-12 17:40:41'),(61,243,NULL,'Interests',2850,'2011-07-12 18:20:43','2011-07-12 18:20:43'),(62,244,NULL,'Profile',500,'2011-07-12 18:24:07','2011-07-12 18:24:07'),(63,244,NULL,'Interests',1350,'2011-07-12 18:29:54','2011-07-12 18:29:54'),(64,244,NULL,'Affiliations',100,'2011-07-12 18:43:40','2011-07-12 18:43:40'),(65,245,NULL,'Profile',500,'2011-07-12 20:28:16','2011-07-12 20:28:16'),(66,245,NULL,'Interests',2100,'2011-07-12 20:30:52','2011-07-12 20:30:52'),(67,245,NULL,'Affiliations',100,'2011-07-12 20:31:26','2011-07-12 20:31:26');
/*!40000 ALTER TABLE `user_credits` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-07-12 22:12:28
