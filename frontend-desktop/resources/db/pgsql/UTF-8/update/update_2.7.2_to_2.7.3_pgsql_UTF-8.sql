-- new file for db changes to 2.7.3-- new file for db changes to 2.7.3

-- replace gettext to handle ' in french translation
DROP FUNCTION gettext(text, text);
CREATE OR REPLACE FUNCTION gettext(locale_arg text, string text)
  RETURNS character varying AS
$BODY$
 DECLARE
    msgstr varchar(512);
    trl RECORD;
 BEGIN
    -- RAISE NOTICE '>%<', locale_arg;

    SELECT INTO trl * FROM translations
    WHERE trim(from locale) = trim(from locale_arg) AND msgid = string;
    -- we return the original string, if no translation is found.
    -- this is consistent with gettext's behaviour
    IF NOT FOUND THEN
        RETURN string;
    ELSE
	--RAISE NOTICE '>%<', trl.msgstr;
	msgstr := replace(trl.msgstr,'''','`');
        RETURN msgstr;
    END IF;
 END;
 $BODY$
  LANGUAGE 'plpgsql' VOLATILE;

--
-- update for franch translation to handle '
--
-- 360
UPDATE translations set msgstr = 'Sauvegarder la vue/l''espace de travail en tant que Web Map Context'
where locale = 'fr' and msgid = 'Save workspace as web map context document';

--379
UPDATE translations set msgstr = 'Carte de''aperçu'
where locale = 'fr' and msgid = 'Overview';

-- 383
UPDATE translations set msgstr = 'Sélection de l''échelle'
where locale = 'fr' and msgid = 'Scale Select';


-- 384
UPDATE translations set msgstr = 'Texte de l''échelle'
where locale = 'fr' and msgid = 'Scale Text';


--386
UPDATE translations set msgstr = 'Sélectionner la carte d''arrière-plan'
where locale = 'fr' and msgid = 'Set Background';

-- update all body elements for guis containing wz_jsgraphics.js
---> otherwise new wz_jsgraphics version leads to an error
UPDATE gui_element set
e_mb_mod = '../extensions/RaphaelJS/raphael-1.4.7.min.js'
where e_id = 'body' and fkey_gui_id IN (SELECT DISTINCT fkey_gui_id FROM gui_element where e_js_file LIKE '%wz_jsgraphics%' OR e_mb_mod LIKE '%wz_jsgraphics%');

--update all gui elements using jquery-ui version 1.8.1 to 1.8.16
update gui_element set e_mb_mod = replace(e_mb_mod, 'jquery-ui-1.8.1.custom', 'jquery-ui-1.8.16.custom') where e_mb_mod LIKE '%jquery-ui-1.8.1.custom%';
--update all gui elements using jquery-ui version 1.8.14 to 1.8.16
update gui_element set e_mb_mod = replace(e_mb_mod, 'jquery-ui-1.8.14.custom', 'jquery-ui-1.8.16.custom') where e_mb_mod LIKE '%jquery-ui-1.8.14.custom%';
--update all gui elements using jquery-ui version 1.7.2 to 1.8.16
update gui_element set e_mb_mod = replace(e_mb_mod, 'jquery-ui-1.7.2.custom', 'jquery-ui-1.8.16.custom') where e_mb_mod LIKE '%jquery-ui-1.7.2.custom%';
--update gui element printPDF -> new file for jquery bgiframe js
update gui_element set e_mb_mod = replace(e_mb_mod, '/external/bgiframe/jquery.bgiframe.min.js', '/external/jquery.bgiframe-2.1.2.js') where e_mb_mod LIKE '%jquery.bgiframe.min.js%';
update gui_element set e_mb_mod = replace(e_mb_mod, '/external/bgiframe/jquery.bgiframe.js', '/external/jquery.bgiframe-2.1.2.js') where e_mb_mod LIKE '%jquery.bgiframe.js%';