
(function($){$.effects.blind=function(o){return this.queue(function(){var el=$(this),props=['position','top','left'];var mode=$.effects.setMode(el,o.options.mode||'hide');var direction=o.options.direction||'vertical';$.effects.save(el,props);el.show();var wrapper=$.effects.createWrapper(el).css({overflow:'hidden'});var ref=(direction=='vertical')?'height':'width';var distance=(direction=='vertical')?wrapper.height():wrapper.width();if(mode=='show')wrapper.css(ref,0);var animation={};animation[ref]=mode=='show'?distance:0;wrapper.animate(animation,o.duration,o.options.easing,function(){if(mode=='hide')el.hide();$.effects.restore(el,props);$.effects.removeWrapper(el);if(o.callback)o.callback.apply(el[0],arguments);el.dequeue();});});};})(jQuery);