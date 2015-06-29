/* 
 * $Id: map_obj.js 2413 2008-04-23 16:21:04Z christoph $
 * COPYRIGHT: (C) 2001 by ccgis. This program is free software under the GNU General Public
 * License (>=v2). Read the file gpl.txt that comes with Mapbender for details. 
 */

//global variables
var wms = [];
var wms_layer_count = 0;

/**
 * global function to add wms to the wms-object
 * 
 * @param {String} wms_id the unique id of the wms 
 * @param {String} wms_version the version assumed from capabilities
 * @param {String} wms_title the title of the wms
 * @param {String} wms_abstract the abstract of the wms
 * @param {String} wms_getmap the url for map requests
 * @param {String} wms_getfeatureinfo the url for featureInof requests
 * @param {String} wms_getlegendurl the url for legend requests
 * @param {String} wms_filter a filter (deprecated)
 * @param {String} gui_wms_mapformat the image-format in the actual gui
 * @param {String} gui_wms_featureinfoformat the current format for featureInfos
 * @param {String} gui_wms_exceptionformat the exceptionformat for map requests
 * @param {String} gui_wms_epsg the current srs
 * @param {Integer} gui_wms_visible the visibility of this service
 * @param {Integer} gui_wms_opacity the initial display opacity in percent
 * @param {String} gui_wms_sldurl url to an actual sld
 */
function add_wms(
	wms_id,
	wms_version,
	wms_title,
	wms_abstract,
	wms_getmap,
	wms_getfeatureinfo,
	wms_getlegendurl,
	wms_filter,
	gui_wms_mapformat,
	gui_wms_featureinfoformat,
	gui_wms_exceptionformat,
	gui_wms_epsg,
	gui_wms_visible,
	gui_wms_opacity,
	gui_wms_sldurl){
	wms[wms.length] = new wms_const(
		wms_id,
		wms_version,
		wms_title,
		wms_abstract,
		wms_getmap,
		wms_getfeatureinfo,
		wms_getlegendurl,
		wms_filter,
		gui_wms_mapformat,
		gui_wms_featureinfoformat,
		gui_wms_exceptionformat,
		gui_wms_epsg,
		parseInt(gui_wms_visible, 10),
		parseInt(gui_wms_opacity),
		gui_wms_sldurl);
	wms_layer[wms.length - 1] = [];
}
/**
 * @class A class representing the wms
 *
 * @constructor
 * @param {String} wms_id the unique id of the wms 
 * @param {String} wms_version the version assumed from capabilities
 * @param {String} wms_title the title of the wms
 * @param {String} wms_abstract the abstract of the wms
 * @param {String} wms_getmap the url for map requests
 * @param {String} wms_getfeatureinfo the url for featureInof requests
 * @param {String} wms_getlegendurl the url for legend requests
 * @param {String} wms_filter a filter (deprecated)
 * @param {String} gui_wms_mapformat the image-format in the actual gui
 * @param {String} gui_wms_featureinfoformat the current format for featureInfos
 * @param {String} gui_wms_exceptionformat the exceptionformat for map requests
 * @param {String} gui_wms_epsg the current srs
 * @param {String} gui_wms_visible the visibility of this service
 * @param {Integer} gui_wms_opacity the initial display opacity in percent
 * @param {String} gui_wms_sldurl url to an actual sld
 * 
 */
function wms_const(  
	wms_id,
	wms_version,
	wms_title,
	wms_abstract,
	wms_getmap,
	wms_getfeatureinfo,
	wms_getlegendurl,
	wms_filter,
	gui_wms_mapformat,
	gui_wms_featureinfoformat,
	gui_wms_exceptionformat,
	gui_wms_epsg,
	gui_wms_visible,
	gui_wms_opacity,
	gui_wms_sldurl){
   
	if (!wms_id) {
		var id_ok = false;
		while (id_ok === false) {
			wms_id = "a"+Math.round(10000*Math.random());
			id_ok = true;
			for (var i=0; i < wms.length && id_ok === true; i++) {
				if (wms_id == wms[i].wms_id) { 
					id_ok = false;
				}
			}
		}
	}
	
	this.wms_id = wms_id;
	this.wms_version = wms_version;
	this.wms_title = wms_title;
	this.wms_currentTitle = wms_title;
	this.wms_abstract = wms_abstract;
	this.wms_getmap = wms_getmap;
	this.wms_getfeatureinfo = wms_getfeatureinfo;
	this.wms_getlegendurl = wms_getlegendurl;
	this.wms_filter = wms_filter;
	this.data_type = [];
	this.data_format = [];
	this.objLayer = [];
	this.gui_wms_mapformat = gui_wms_mapformat;
	this.gui_wms_featureinfoformat = gui_wms_featureinfoformat;
	this.gui_wms_exceptionformat = gui_wms_exceptionformat;
	this.gui_wms_epsg = gui_wms_epsg;
	this.gui_wms_visible = gui_wms_visible;
	this.gui_epsg = [];
	this.gui_epsg_supported = [];
	this.gui_minx = [];
	this.gui_miny = [];
	this.gui_maxx = [];
	this.gui_maxy = [];
	
	// opacity version
	this.gui_wms_mapopacity = gui_wms_opacity/100;
	// sld version
	this.gui_wms_sldurl = gui_wms_sldurl;    

	this.setCrs = function (options) {
		var crsIndex = $.inArray(options.source.srsCode, this.gui_epsg);
		if (crsIndex !== -1 && 
			typeof this.gui_minx[crsIndex] === 'number' &&
			typeof this.gui_miny[crsIndex] === 'number' &&	
			typeof this.gui_maxx[crsIndex] === 'number' &&
			typeof this.gui_maxy[crsIndex] === 'number'
			) {
			var sw = new Proj4js.Point(
				this.gui_minx[crsIndex], 
				this.gui_miny[crsIndex]
				);
			var ne = new Proj4js.Point(
				this.gui_maxx[crsIndex], 
				this.gui_maxy[crsIndex]
				);
			sw = Proj4js.transform(options.source, options.dest, sw);
			ne = Proj4js.transform(options.source, options.dest, ne);
			var extent = new Mapbender.Extent(sw.x, sw.y, ne.x, ne.y);
			this.setBoundingBoxBySrs(options.dest.srsCode, extent);
		}
		else {
			this.setBoundingBoxBySrs(options.dest.srsCode);
		}
	};
	
	this.setBoundingBoxBySrs = function (srs, ext) {
		for (var i = 0; i < this.gui_epsg.length && ext !== undefined; i++) {
			if (srs == this.gui_epsg[i]) {
				this.gui_minx[i] = parseFloat(ext.minx);
				this.gui_miny[i] = parseFloat(ext.miny);
				this.gui_maxx[i] = parseFloat(ext.maxx);
				this.gui_maxy[i] = parseFloat(ext.maxy);
				return i;
			}
		}
		this.gui_epsg.push(srs);
		this.gui_epsg_supported.push(false);
		
		if (ext !== undefined) {
			this.gui_minx.push(ext.minx);
			this.gui_miny.push(ext.miny);
			this.gui_maxx.push(ext.maxx);
			this.gui_maxy.push(ext.maxy);
		}
		
		return this.gui_epsg.length - 1;
	};
}

wms_const.prototype.getBoundingBoxBySrs = function (srs) {
	for (var i = 0; i < this.gui_epsg.length; i++) {
		if (srs == this.gui_epsg[i]) {
			var bbox_minx = parseFloat(this.gui_minx[i]);
			var bbox_miny = parseFloat(this.gui_miny[i]);
			var bbox_maxx = parseFloat(this.gui_maxx[i]);
			var bbox_maxy = parseFloat(this.gui_maxy[i]);
			if (bbox_minx !== null && !isNaN(bbox_minx) &&
				bbox_miny !== null && !isNaN(bbox_miny) &&
				bbox_maxx !== null && !isNaN(bbox_maxx) &&
				bbox_maxy !== null && !isNaN(bbox_maxy)
				) {
				return new Extent(bbox_minx, bbox_miny, bbox_maxx, bbox_maxy);
			}
		}
	}
	return null;
};

/**
 * rephrases the featureInfoRequest
 *
 * @param {Object} mapObj the mapbender mapObject of the wms  
 * @param {Point} clickPoint map-click position {@link Point}
 * @return featureInfoRequest, onlineresource + params
 * @type string
 */
wms_const.prototype.getFeatureInfoRequest = function(mapObj, clickPoint){	
	
	//check layers and querylayers first 
	var layers = this.getLayers(mapObj);
	var querylayers = this.getQuerylayers(mapObj);
	
	if(!layers || !querylayers){
		return false;
	}
	
	var rq = this.wms_getfeatureinfo;
	rq += mb_getConjunctionCharacter(this.wms_getfeatureinfo);
	if(this.wms_version === "1.0.0"){
		rq += "WMTVER=" + this.wms_version + "&REQUEST=feature_info";
	}
	else{
		rq += "VERSION=" + this.wms_version + "&REQUEST=GetFeatureInfo&SERVICE=WMS";
	}
	
	rq += "&LAYERS=" + layers.join(",");
	rq += "&QUERY_LAYERS=" + querylayers.join(",");
	rq += "&WIDTH=" + mapObj.getWidth();
	rq += "&HEIGHT=" + mapObj.getHeight();
	rq += "&SRS=" + mapObj.getSRS();
	rq += "&BBOX=" + mapObj.getExtent();
	rq += "&STYLES=" + this.getLayerstyles(mapObj).join(",");
	rq += "&FORMAT=" + this.gui_wms_mapformat;
	rq += "&INFO_FORMAT=" + this.gui_wms_featureinfoformat;
	rq += "&EXCEPTIONS=application/vnd.ogc.se_xml";
	rq += "&X=" + clickPoint.x;
	rq += "&Y=" + clickPoint.y;
	if(mb_feature_count > 0){             
		rq += "&FEATURE_COUNT="+mb_feature_count;
	}
	rq += "&";
	// add vendor-specific
	var currentWms = this;
	for (var v = 0; v < mb_vendorSpecific.length; v++) {
		var functionName = 'setFeatureInfoRequest';
		var currentWms_wms_title = this.wms_title;
		var vendorSpecificString = eval(mb_vendorSpecific[v]);
		// if eval doesn't evaluate a function, the result is undefined.
		// Sometimes it is necessary not to evaluate a function, for
		// example if you want to change a variable from the current
		// scope (see mod_addSLD.php) 
		if (typeof(vendorSpecificString) != "undefined") {
			rq += vendorSpecificString + "&";
			try {
				if (this.wms_title == removeLayerAndStylesAffectedWMSTitle) {
					rq = url.replace(/LAYERS=[^&]*&/, '');
					rq = url.replace(/STYLES=[^&]*&/, '');
				}
			}
			catch (exc) {
				new Mb_warning(exc.message);
			}
		}
	}
	return rq;
};

/**
 * sets Opacity of WMS
 * 
 * @param {Integer} new opacity percentage value
 */
wms_const.prototype.setOpacity = function(opacity){
	//calc new opacity
	this.gui_wms_mapopacity = parseInt(opacity)/100;
	if(this.gui_wms_mapopacity>1||isNaN(this.gui_wms_mapopacity))
		this.gui_wms_mapopacity=1;
	if(this.gui_wms_mapopacity<0)
		this.gui_wms_mapopacity=0;
		
	if (this.gui_wms_visible > 0) {

		//get div id
		var divId = null;
		for (var i=0; i < wms.length; i++) {
			if (this.wms_id == wms[i].wms_id) { 
				var divId = 'div_'+i;
				break;
			}
		}
		if(!divId)
			return;	
		
		//TODO: check if mapframe1 is the right mapframe
		var ind = getMapObjIndexByName("mapframe1");
		var el = mb_mapObj[ind].getDomElement();
		wmsImage = el.ownerDocument.getElementById(divId);
		if (wmsImage != null) {
			wmsImage.style.opacity = this.gui_wms_mapopacity;
			wmsImage.style.MozOpacity = this.gui_wms_mapopacity;
			wmsImage.style.KhtmlOpacity = this.gui_wms_mapopacity;
			wmsImage.style.filter = "alpha(opacity=" + this.gui_wms_mapopacity*100 + ")";
		}
	}
}

/**
 * get all visible layers
 *
 * @return array of layernames 
 * @type string[]
 */
wms_const.prototype.getLayers = function(mapObj){
	var scale = null;
	if (arguments.length === 2) {
		scale = arguments[1];
	}
	try {
		//visibility of the wms
		var wmsIsVisible = (this.gui_wms_visible > 0);
		if(!wmsIsVisible){
			return [];
		}
		visibleLayers = [];
		for(var i=0; i< this.objLayer.length; i++){
			var isVisible = (this.objLayer[i].gui_layer_visible === 1);
			var hasNoChildren = (!this.objLayer[i].has_childs);
			if (isVisible && hasNoChildren){
				if(this.objLayer[i].checkScale(mapObj, scale)){
					visibleLayers.push(this.objLayer[i].layer_name);
				}
			}
		}
		if(visibleLayers.length === 0){
			return [];
		}
		return visibleLayers;
	}
	catch (e) {
		alert(e);
	}
	return [];
};

/**
 * get the actual style of all visible layers
 *
 * @return commaseparated list of actual layerstyles
 * @type string
 */
wms_const.prototype.getLayerstyles = function(mapObj){
	
	var layers = this.getLayers(mapObj);
	var layerstyles = '';
	var styles = [];
	if(layers){
		for(i = 0; i < layers.length; i++){
			var style = this.getCurrentStyleByLayerName(layers[i]);
			if(!style){
				style = '';
			}
			styles.push(style);
		}
		return styles;
	}
	return false;
};

/**
 * check if layer is parentLayer
 *
 * @param layername
 * @return the parent value of the given layer
 * @type integer
 */
wms_const.prototype.checkLayerParentByLayerName = function(layername){
	for(var i=0; i< this.objLayer.length; i++){
		if(this.objLayer[i].layer_name == layername){
			return this.objLayer[i].layer_parent;
		}
	}
};

/**
 * get the title of the current layer
 *
 * @param layername
 * @return the title of the given layer
 * @type string
 */
wms_const.prototype.getTitleByLayerName = function(layername){
	for(var i=0; i< this.objLayer.length; i++){
		if(this.objLayer[i].layer_name == layername){
			return this.objLayer[i].layer_title;
		}
	}
};

wms_const.prototype.getLayerByLayerName = function(layername){
	for(var i=0; i< this.objLayer.length; i++){
		if(this.objLayer[i].layer_name === layername){
			return this.objLayer[i];
		}
	}
};

/**
 * get the current style of the layer
 *
 * @param layername
 * @return the stylename of the given layer
 * @type string
 */
wms_const.prototype.getCurrentStyleByLayerName = function(layername){
	for(var i=0; i< this.objLayer.length; i++){
		var currentLayer = this.objLayer[i];
		if (currentLayer.layer_name === layername) {
			if (currentLayer.gui_layer_style === '' || currentLayer.gui_layer_style === null){
				return "";
			//				return false;
			}
			else{
				return currentLayer.gui_layer_style;	
			}
		}
	}
	return false;
};

/**
 * get the legendurl of the gui layer style
 *
 * @param stylename
 * @return the legendurl of the given style
 * @type string
 */
wms_const.prototype.getLegendUrlByGuiLayerStyle = function(layername,guiLayerStyle){
	for(var i=0; i< this.objLayer.length; i++){
		if(this.objLayer[i].layer_name == layername){
			if(this.objLayer[i].layer_style.length === 0){
				return false;
			}
			for(var k=0; k< this.objLayer[i].layer_style.length; k++){
				var legendUrl = '';
				if(guiLayerStyle == '' && k == 0){
					legendUrl = this.objLayer[i].layer_style[k].legendurl;
					if (this.gui_wms_sldurl !== "") {
						legendUrl += "&SLD="+escape(this.gui_wms_sldurl);
					}				
					if(legendUrl !=='' && legendUrl !== null && typeof(legendUrl) != 'undefined'){
						return legendUrl;
					}
					else {
						return false;
					}
				}else if(this.objLayer[i].layer_style[k].name == guiLayerStyle){
					legendUrl = this.objLayer[i].layer_style[k].legendurl;
					if (this.gui_wms_sldurl !== "") {
						legendUrl += "&SLD="+escape(this.gui_wms_sldurl);
					}				
					if(legendUrl !=='' && legendUrl !== null && typeof(legendUrl) != 'undefined'){
						return legendUrl;
					}
					else {
						return false;
					}
				}
			}
		}
	}
	return false;
};

/**
 * get all querylayers
 *
 * @return array of layernames
 * @type string[]
 */
wms_const.prototype.getQuerylayers = function(map){
	var currentScale = map.getScale();
	queryLayers = [];
	for(var i=0; i< this.objLayer.length; i++){
		
		var isVisible = this.objLayer[i].gui_layer_visible === 1 && 
		this.objLayer[i].gui_layer_minscale <= currentScale &&
		(this.objLayer[i].gui_layer_maxscale >= currentScale ||
			this.objLayer[i].gui_layer_maxscale === 0);
		if(this.objLayer[i].gui_layer_querylayer === 1 && !this.objLayer[i].has_childs && isVisible){
			queryLayers.push(this.objLayer[i].layer_name);
		}
	}
	if(queryLayers.length === 0){
		return false;
	}
	return queryLayers;
};

/**
 * get a layer Object by layer_pos
 * 
 * @param int payer_pos layer_pos of layer you want to get
 * @return object layer
 */

wms_const.prototype.getLayerByLayerPos = function(layer_pos){
	for(var i=0;i<this.objLayer.length;i++){
		if(this.objLayer[i].layer_pos == layer_pos) {
			return this.objLayer[i];
		}
	}
	return null;
};

wms_const.prototype.getLayerById = function(id){
	for(var i=0;i<this.objLayer.length;i++){
		if(parseInt(this.objLayer[i].layer_uid, 10) === parseInt(id,10)) {
			return this.objLayer[i];
		}
	}
	return null;
};
/**
 * get the state of sublayers from a specified layer
 * 
 * @param int layer_id of the parent layer
 * @param String type "visible" or "querylayer"
 * @return int -1 if state differs else the state
 */

wms_const.prototype.getSublayerState = function(layer_id, type){
	var i;
	var state=-1,value;
	for(i = 0; i < this.objLayer.length; i++){
		if(this.objLayer[i].layer_id==layer_id) {
			break;
		}
	}
	
	//go throught sublayers
	for(var j = i+1; j < this.objLayer.length; j++){
		if(this.objLayer[i].parent_layer == this.objLayer[j].parent_layer) {
			break;
		}
		if(type == "visible") {
			value = this.objLayer[j].gui_layer_visible;
		}
		else if(type == "querylayer") {
			value = this.objLayer[j].gui_layer_querylayer;
		}
		if(state == -1) {
			state = value;
		}
		if(state != value) {
			return -1;
		}
	}
	
	return state;
};
/**
 * handle change of visibility / quaryability of a layer
 * 
 * @param string layer_name of layer to handle
 * @param string type of change ("visible" or "querylayer")
 * @param int value of the change
 */
wms_const.prototype.handleLayer = function(layer_name, type, value){
	var i;
	var found = false;
	for(i = 0; i < this.objLayer.length; i++){
		if(this.objLayer[i].layer_name==layer_name) {
			found = true;
			break;
		}
	}
	// layer not found
	if (!found) {
		return;
	}
	
	//Set visibility/queryability of Layer and Sublayers
	for(var j = i; j < this.objLayer.length; j++){
		if (i != j && this.objLayer[i].layer_parent >= this.objLayer[j].layer_parent) {
			break;
		}
		if(type == "visible") {
			this.objLayer[j].gui_layer_visible = parseInt(value, 10);
		}
		else if(type=="querylayer" && this.objLayer[j].gui_layer_queryable) {
			this.objLayer[j].gui_layer_querylayer = parseInt(value, 10);
		}
	}

	//Update visibility/queryability of parent layer
	var parentLayer = this.getLayerByLayerPos(this.objLayer[i].layer_parent);
	if(parentLayer){
		var state = this.getSublayerState(parentLayer.layer_id, type);
		if(state!=-1){
			if(type == "visible") {
				this.objLayer[j].gui_layer_visible = state;
			}
			else if(type=="querylayer" && this.objLayer[j].gui_layer_queryable) {
				this.objLayer[j].gui_layer_querylayer = state;
			}
		}
	}
};


/**
 * move a layer (with his sublayers) up or down
 * 
 * @param int layerId layer_id of layer to move
 * @param boolean moveUp true to move up or false to move down
 * @return boolean success
 */

wms_const.prototype.moveLayer = function(layerId, moveUp){
	var iLayer=-1;
	var i;
	
	//find layer to move
	for(i=0;i<this.objLayer.length;i++){
		if(this.objLayer[i].layer_id==layerId){
			iLayer=i;
			break;
		}
	}
	if(iLayer==-1) {
		return false;
	}
	
	var upperLayer = -1;
	var lowerLayer = -1;
	
	//find layer to swap position with
	var parentLayer = this.objLayer[iLayer].layer_parent;	
	if(moveUp){
		lowerLayer = iLayer;
		
		//find previous layer on same level
		for(i=iLayer-1;i>0;i--){
			if(parentLayer == this.objLayer[i].layer_parent){
				upperLayer = i;
				break;
			}
		}
		if(upperLayer == -1){
			//alert("The Layer you selected is already on top of parent Layer/WMS");
			return false;
		}
	}
	else{
		upperLayer = iLayer;
		
		//find next layer on same level
		for(i=iLayer+1;i<this.objLayer.length;i++){
			if(parentLayer == this.objLayer[i].layer_parent){
				lowerLayer = i;
				break;
			}
		}
		if(lowerLayer == -1){
			//alert("The Layer you selected is already on bottom of parent Layer/WMS");
			return false;
		}
	}
	
	//calc number of layers to move down
	var layersDown = lowerLayer - upperLayer;
	
	//get number of layers to move up
	for(i=lowerLayer+1; i<this.objLayer.length; i++){
		if(parentLayer == this.objLayer[i].layer_parent){
			break;
		}
	}
	var layersUp = i - lowerLayer;
	
	//do moving
	var temp = [];
	for(i=0;i<layersDown+layersUp;i++){
		temp[temp.length]=this.objLayer[upperLayer+i];
	}
	for(i=0;i<layersUp;i++){
		this.objLayer[upperLayer+i]=temp[i+layersDown];
	}
	for(i=0;i<layersDown;i++){
		this.objLayer[upperLayer+layersUp+i]=temp[i];
	}

	return true;
};

function wms_add_data_type_format(datatype,dataformat){
	var insertDataFormat = true;
	for (var i = 0 ; i < wms[wms.length-1].data_type.length ; i ++) {
		if (wms[wms.length-1].data_type[i] == datatype && wms[wms.length-1].data_format[i] == dataformat) {
			insertDataFormat = false;
		}
	}
	if (insertDataFormat === true) {
		wms[wms.length-1].data_type[wms[wms.length-1].data_type.length] = datatype;
		wms[wms.length-1].data_format[wms[wms.length-1].data_format.length] = dataformat;
	}
}
function wms_addSRS(epsg,minx,miny,maxx,maxy){
	wms[wms.length-1].gui_epsg[wms[wms.length-1].gui_epsg.length] = epsg;
	wms[wms.length-1].gui_epsg_supported[wms[wms.length-1].gui_epsg_supported.length] = true;
	wms[wms.length-1].gui_minx[wms[wms.length-1].gui_minx.length] = minx;
	wms[wms.length-1].gui_miny[wms[wms.length-1].gui_miny.length] = miny;
	wms[wms.length-1].gui_maxx[wms[wms.length-1].gui_maxx.length] = maxx;
	wms[wms.length-1].gui_maxy[wms[wms.length-1].gui_maxy.length] = maxy;
}
function wms_addLayerStyle(styleName, styleTitle, count, layerCount, styleLegendUrl, styleLegendUrlFormat){
	//TODO for debug purposes:	
	//alert(styleName+":"+styleTitle+":"+count+":"+layerCount+":"+styleLegendUrl+":"+styleLegendUrlFormat);
	//var test = wms.length-1;
	//alert("add layer style["+count+"] for layer["+layerCount+"] for wms["+test+"]:"+styleLegendUrl);
	var currentLayer = wms[wms.length-1].objLayer[layerCount]; 

	if (currentLayer) {
		currentLayer.layer_style[count] = {};
		currentLayer.layer_style[count].name = styleName;
		currentLayer.layer_style[count].title = styleTitle;
		currentLayer.layer_style[count].legendurl = styleLegendUrl;
		currentLayer.layer_style[count].legendurlformat = styleLegendUrlFormat;
	}
}
//TODO: add layerstyle handling....
//layer
function wms_add_layer(
	layer_parent,
	layer_uid,
	layer_name,
	layer_title,
	layer_dataurl_href,
	layer_pos,
	layer_queryable,
	layer_minscale,
	layer_maxscale,
	layer_metadataurl,
	gui_layer_wms_id,
	gui_layer_status,
	gui_layer_style,
	gui_layer_selectable,
	gui_layer_visible,
	gui_layer_queryable,
	gui_layer_querylayer,
	gui_layer_minscale,
	gui_layer_maxscale,
	gui_layer_wfs_featuretype,
	gui_layer_title){
                      
	wms[wms.length-1].objLayer[wms[wms.length-1].objLayer.length] = new wms_layer(
		layer_parent,
		layer_uid,
		layer_name,
		layer_title,
		layer_dataurl_href,
		layer_pos,
		layer_queryable,
		layer_minscale,
		layer_maxscale,
		layer_metadataurl,
		gui_layer_wms_id,
		gui_layer_status,
		gui_layer_style,
		parseInt(gui_layer_selectable, 10),
		parseInt(gui_layer_visible, 10),
		parseInt(gui_layer_queryable, 10),
		parseInt(gui_layer_querylayer, 10),
		parseInt(gui_layer_minscale, 10),
		parseInt(gui_layer_maxscale, 10),
		gui_layer_wfs_featuretype,
		gui_layer_title );
	var parentLayer = wms[wms.length-1].getLayerByLayerPos(parseInt(layer_parent, 10));
	if(parentLayer) {
		parentLayer.has_childs = true;
	}
}
function layer_addEpsg(epsg,minx,miny,maxx,maxy){
	var j = wms[wms.length-1].objLayer.length-1;
	var k = wms[wms.length-1].objLayer[j].layer_epsg.length;
	var currentLayer = wms[wms.length-1].objLayer[j];
	currentLayer.layer_epsg[k]={};
	currentLayer.layer_epsg[k].epsg = epsg;
	currentLayer.layer_epsg[k].minx = minx;
	currentLayer.layer_epsg[k].miny = miny;
	currentLayer.layer_epsg[k].maxx = maxx;
	currentLayer.layer_epsg[k].maxy = maxy;
}
function wms_layer(
	layer_parent,
	wms_layer_uid,
	layer_name,
	layer_title,
	layer_dataurl_href,
	layer_pos,
	layer_queryable,
	layer_minscale,
	layer_maxscale,
	layer_metadataurl,
	gui_layer_wms_id,
	gui_layer_status,
	gui_layer_style,
	gui_layer_selectable,
	gui_layer_visible,
	gui_layer_queryable,
	gui_layer_querylayer,
	gui_layer_minscale,
	gui_layer_maxscale,
	gui_layer_wfs_featuretype,
	gui_layer_title){
	this.layer_id = wms_layer_count;
	this.layer_uid = wms_layer_uid;
	this.layer_parent = layer_parent;
	this.layer_name = layer_name;
	this.layer_title = layer_title;
	this.gui_layer_title = gui_layer_title || layer_title;
	this.layer_currentTitle = this.gui_layer_title;
	this.layer_dataurl_href = layer_dataurl_href;
	this.layer_pos = layer_pos;
	this.layer_queryable = layer_queryable;
	this.layer_minscale = layer_minscale;
	this.layer_maxscale = layer_maxscale;
	this.layer_metadataurl = layer_metadataurl;
	this.layer_epsg = [];
	this.gui_layer_wms_id = gui_layer_wms_id;
	this.gui_layer_status = gui_layer_status;
	this.gui_layer_selectable = gui_layer_selectable;
	this.gui_layer_visible = gui_layer_visible;
	this.gui_layer_queryable = gui_layer_queryable;
	this.gui_layer_querylayer = gui_layer_querylayer;
	this.gui_layer_minscale = gui_layer_minscale;
	this.gui_layer_maxscale = gui_layer_maxscale;
	this.gui_layer_style = gui_layer_style;
	this.gui_layer_wfs_featuretype = gui_layer_wfs_featuretype;
	this.has_childs = false;
	this.layer_style = [];
	wms_layer_count++;
}
/**
 * check the scale of the layer
 *
 * @param Object mapObj the mapbender mapObject of the layer
 * @return boolean if the layer is in scale or not
 * @type boolean
 */
wms_layer.prototype.checkScale = function(mapObj){
	var currentScale = parseInt(mapObj.getScale(), 10);
	if (arguments.length === 2 && arguments[1] !== null) {
		currentScale = arguments[1];
	}
	var minScale = parseInt(this.gui_layer_minscale, 10);
	var maxScale = parseInt(this.gui_layer_maxscale, 10);
	if(minScale === 0 && maxScale === 0){
		return true;
	}
	if(minScale > currentScale || (maxScale !== 0 && maxScale < currentScale)) {
		return false;
	}	
	return true;
};
/**
 * set visibility of the layer
 * @param boolean visible visibility on/off
 */
wms_layer.prototype.setVisible = function(visible){
	this.gui_layer_visible = parseInt(visible, 10);
};

/**
 * set queryability of the layer
 * @param boolean queryable queryability on/off
 */

wms_layer.prototype.setQueryable = function(queryable){
	this.gui_layer_querylayer = parseInt(queryable, 10);
};
