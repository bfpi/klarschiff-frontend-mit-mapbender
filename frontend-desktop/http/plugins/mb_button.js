/**
 * Package: button
 *
 * Description:
 * Imagine you have a DIV element in your application. In order to save screen
 * real estate, you might want to only show the DIV if the user clicked a
 * button. That's what this module does. The button will open a dialog
 * containing the element specified in the target column. In the example, a
 * button will open the print form in a new dialog.
 *
 * Files:
 *  - ../plugins/mb_button.js
 *
 * SQL:
 * > INSERT INTO gui_element(fkey_gui_id, e_id, e_pos, e_public, e_comment,
 * > e_title, e_element, e_src, e_attributes, e_left, e_top, e_width, e_height,
 * > e_z_index, e_more_styles, e_content, e_closetag, e_js_file, e_mb_mod,
 * > e_target, e_requires, e_url) VALUES('<appId>','printButton',1,1,'',
 * > 'Print','img','../img/button_blue_red/print_off.png','',NULL ,NULL ,24,24,
 * > NULL ,'','','','../plugins/mb_button.js','','printPDF','','');
 * >
 * > INSERT INTO gui_element_vars(fkey_gui_id, fkey_e_id, var_name, var_value, 
 * > context, var_type) VALUES('<appId>', 
 * > 'printButton', 'position', '[600,100]', '' ,'var');
 * 
 * Maintainer:
 * http://www.mapbender.org/User:Christoph_Baudson
 *
 * Parameters:
 *
 * License:
 * Copyright (c) 2009, Open Source Geospatial Foundation
 * This program is dual licensed under the GNU General Public License
 * and Simplified BSD license.
 * http://svn.osgeo.org/mapbender/trunk/mapbender/license/license.txt
 */

var $button = $(this);

var ButtonApi = function (o) {
    o.position = o.position || 'center';
	var that = this;
	var target = (o.$target && o.$target.jquery && o.$target.size() === 1) ?
		o.$target : $([]);
	var dialog = target.css({
		position: "static",
		width: "auto",
		height: "auto",
		top: "auto",
		left: "auto"
	}).hide().dialog({
		autoOpen: false,
		position: o.position,
                dialogClass: o.target + "-dialog"
        });

        var openDialog = function () {
		dialog.dialog("open");
		button.stop();
	};

	var button = new Mapbender.Button({
		domElement: $button.get(0),
		over: o.src.replace(/_off/, "_over"),
		on: o.src.replace(/_off/, "_on"),
		off: o.src,
		name: o.id,
		go: openDialog
	});
};

$button.mapbender(new ButtonApi(options));