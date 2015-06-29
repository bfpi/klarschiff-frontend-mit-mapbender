
SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('gui_treegde', 'id'), (Select max(id) from gui_treegde), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('layer', 'layer_id'), (Select max(layer_id) from layer), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('mb_group', 'mb_group_id'), (Select max(mb_group_id) from mb_group), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('mb_log', 'id'), (Select max(id) from mb_log), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('mb_user', 'mb_user_id'), (Select max(mb_user_id) from mb_user), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('wfs', 'wfs_id'), (Select max(wfs_id) from wfs), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('wfs_conf', 'wfs_conf_id'), (Select max(wfs_conf_id) from wfs_conf), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('wfs_conf_element', 'wfs_conf_element_id'), (Select max(wfs_conf_element_id) from wfs_conf_element), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('wfs_element', 'element_id'), (Select max(element_id) from wfs_element), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('wfs_featuretype', 'featuretype_id'), (Select max(featuretype_id) from wfs_featuretype), true);


SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('wms', 'wms_id'), (Select max(wms_id) from wms), true);

-- new sequences from Mapbender version 2.4.1
SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('keyword', 'keyword_id'), (Select max(keyword_id) from keyword), true);
SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('md_topic_category', 'md_topic_category_id'), (Select max(md_topic_category_id) from md_topic_category), true);

-- new sequences from Mapbender version 2.5
SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('translations', 'trs_id'), (Select max(trs_id) from translations), true);
SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('gui_kml', 'kml_id'), (Select max(kml_id) from gui_kml), true);

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('sld_user_layer', 'sld_user_layer_id'), (Select max(sld_user_layer_id) from sld_user_layer), true);

