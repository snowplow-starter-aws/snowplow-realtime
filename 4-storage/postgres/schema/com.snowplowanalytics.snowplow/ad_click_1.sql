-- Copyright (c) 2014 Snowplow Analytics Ltd. All rights reserved.
--
-- This program is licensed to you under the Apache License Version 2.0,
-- and you may not use this file except in compliance with the Apache License Version 2.0.
-- You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the Apache License Version 2.0 is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
--
-- Authors:       Alex Dean
-- Copyright:     Copyright (c) 2014 Snowplow Analytics Ltd
-- License:       Apache License Version 2.0
--
-- Compatibility: iglu:com.snowplowanalytics.snowplow/ad_click/jsonschema/1-0-0

CREATE TABLE atomic.com_snowplowanalytics_snowplow_ad_click_1 (
	-- Schema of this type
	schema_vendor  varchar(128)    not null,
	schema_name    varchar(128)    not null,
	schema_format  varchar(128)    not null,
	schema_version varchar(128)    not null,
	-- Parentage of this type
	root_id        char(36)        not null,
	root_tstamp    timestamp       not null,
	ref_root       varchar(255)    not null,
	ref_tree       varchar(1500)   not null,
	ref_parent     varchar(255)    not null,
	-- Properties of this type
	click_id       varchar(255)   ,
	impression_id  varchar(255)   ,
	zone_id        varchar(255)   ,
	banner_id      varchar(255)   ,
	campaign_id    varchar(255)   ,
	advertiser_id  varchar(255)   ,
	target_url     varchar(4096)  ,
	cost_model     char(3)        ,
	cost           decimal(15,2) ,
	FOREIGN KEY(root_id) REFERENCES atomic.events(event_id)
)
-- DISTSTYLE KEY
-- Optimized join to atomic.events
-- DISTKEY (root_id)
-- SORTKEY (root_tstamp);
