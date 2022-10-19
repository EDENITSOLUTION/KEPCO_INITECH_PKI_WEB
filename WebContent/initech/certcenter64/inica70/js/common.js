/*right_side slider*/
$(function(){
	var menuFlag = false;
	$("#LocationTxt").text( $(".lastLocation").find(".on").text() );
	$('.flexslider').flexslider({ animation: "slide", pauseOnHover: true });	
	$(".sMenu").bind("focusin mouseover" , function(){		
		$(".sMenu").addClass("on");
		$(this).stop().animate({ "height" : "210px" }, 200);	
	}).bind("focusout mouseleave" , function(){				
		$(".sMenu").removeClass("on");
		$(this).stop().animate({ "height" : "42px" }, 200);	
	});
	$(".nb > ul > .on").bind("focusin mouseover" , function(){
		var w = $(this).width()-2;
		$(this).find("ul").width(w).show();
	}).bind("focusout mouseleave" , function(){
		$(this).find("ul").hide();
	});

	$(".top_btn").click(function(){
		$('body, html').animate({ scrollTop: 0 }, "fast");
	});
	// TOP ��ư Ȱ��ȭ
	$(window).scroll(function(){
		var scrollTop = $(document).scrollTop();				
		if (scrollTop > 200 )
			$(".top_btn").show();
	});

	// SIDE > ������
	$(".divide a").click(function(){
		$(".divide a").removeClass("on");
		$(".btnWrap").hide();
		$(this).addClass("on");
		$("#"+$(this).attr("data-id")).show();
	});
});

// ���հ˻�
function _combineSubmit(f){	
	if (!f.m_query.value)
	{
		alert('�˻�� �Է��ϼ���.');
		f.m_query.focus();
		return;
	}
	location.href = '/search/&m_query='+f.m_query.value;
}
function _searchSubmit(f){
	var param='';
	if (!f.m_query.value)
	{
		alert('�˻�� �Է��ϼ���.');
		f.m_query.focus();
		return;
	}	
	if (f.cate.value)
	{
		param += '&cate='+f.cate.value;
	}
	if (f.theme.value)
	{
		param += '&theme='+f.theme.value;
	}	
	location.href = '/search/&m_query='+f.m_query.value+param;
}

/* Layer */
var is_mask_run = false;
//$(window).resize(function() {if(is_mask_run){modalWindow();}}); 
//$(window).scroll(function() {if(is_mask_run){modalWindow();}}); 
function modalWindow(id) {
	if (!id)
		id = 'layerWrap';
	
	// Ȱ��ȭ    
	is_mask_run = true;         
	
	// ����ũ ������    
	var maskHeight = $(document).height();    
	var maskWidth = $(window).width();    
	$('#layerMask').css({'width':maskWidth,'height':maskHeight});     
	
	// ����ũ effect      
	$('#layerMask').fadeTo("slow",0.8);      
	
	// ������ ȭ�� ������ ���ϱ�    
	var winH = $(window).height();    
	var winW = $(window).width();     
	
	// ��ũ�� ���� ���ϱ�    
	var _y =(window.pageYOffset) ? window.pageYOffset   
	: (document.documentElement && document.documentElement.scrollTop) ? document.documentElement.scrollTop   
	: (document.body) ? document.body.scrollTop : 0;     
	
	if(_y<1) var h = winH/2;   
	else var h = winH/2+_y;   

	// dialogâ ��������    
	var dial_width =$('#'+id).width();    
	var dial_height = $('#'+id).height();    
	$('#'+id).css({'width':dial_width,'height':dial_height});    
	if (dial_height > $(window).height() )
		$('#'+id).css('top', 50);   		
	else
		$('#'+id).css('top', h-dial_height/2-150);
	$('#'+id).css('left', winW/2-dial_width/2); 
	$('#'+id).show();
}

function layerClose(id)
{
	if (!id) {
		$('#layerMask').hide();
		$('.layerWrap').hide();
	} else {
		$('#layerMask').hide();
		$('#' + id).hide();
	}

	
	is_mask_run= false;
}
// �̸��� ���� ����
function emailChg(v,id)
{
	if ( v != "" ) {		
		$("#"+id).attr("readonly", true);
	} else {
		$("#"+id).attr("readonly", false);
	}
	$("#"+id).val(v);
}

function printAction() {
 window.open("/print_hidden.php", "hiddenFrame");
 window.frames['hiddenFrame'].focus();
}

function clipboard(text)
{
	var IE=(document.all)?true:false;
	if (IE)
	{
		window.clipboardData.setData('Text',text);
		alert("Ŭ�����忡 ����Ǿ����ϴ�.");
	}	
	else
	{
		temp = prompt("Ctrl+C�� ���� �����ϼ���", text);
	}
}

function showLoading() {
	// ����ũ ������    
	var maskHeight = $(document).height();    
	var maskWidth = $(window).width();    
	$('#loadingMask').css({'width':maskWidth,'height':maskHeight});     
	
	// ����ũ effect      
	$('#loadingMask').fadeTo("slow",0.8);  
	
	// ������ ȭ�� ������ ���ϱ�    
	var winH = $(window).height();    	
	
	// ��ũ�� ���� ���ϱ�    
	var _y =(window.pageYOffset) ? window.pageYOffset   
	: (document.documentElement && document.documentElement.scrollTop) ? document.documentElement.scrollTop   
	: (document.body) ? document.body.scrollTop : 0;     
	
	if(_y<1) var h = winH/2;   
	else var h = winH/2+_y;   
	
	var loadingImg = $("<img/>").attr('src', '/images/common/loading.gif');
	var tmp = $("<div style='height:; text-align:center; margin-top:" + h + "px;'/>").attr("id", "temp").html(loadingImg);

	//$('#loadingMask').css('background', 'none');
	$('#loadingMask').html(tmp).show();	
}





function dspCopyRight(){
	document.write("<!----------------------------->");
	document.write("<!-- COPYRIGHT MENU Start    -->");
	document.write("<!----------------------------->");
	document.write("<div id='footersub'>");
	document.write("	<ul>");
	document.write("		<li class='img'><img src='img/footer_logo.gif' alt='�ѱ����°���'></li>");
	document.write("		<li class='ads'>(��)58217 ���󳲵� ���ֽ� ���·� 55 (�������� 120) Copyright@2016 KEPCO. All Rights Reserved.<br /> <span style='color:#ffffff'>66</span></li>");
	document.write("		<li class='rig'>&nbsp;</li>");
	document.write("	</ul>");
	document.write("</div>");
	document.write("<!----------------------------->");
	document.write("<!-- COPYRIGHT MENU End ------->");
	document.write("<!----------------------------->");
}

function dspMainCopyRight(){
	document.write("<!----------------------------->");
	document.write("<!-- COPYRIGHT MENU Start    -->");
	document.write("<!----------------------------->");
	document.write("<div id='footer'>");
	document.write("	<ul>");
	document.write("		<li class='img'><img src='img/footer_logo.gif' alt='�ѱ����°���'></li>");
	document.write("		<li class='ads'>(��)58217 ���󳲵� ���ֽ� ���·� 55 (�������� 120) Copyright@2016 KEPCO. All Rights Reserved.<br /> <span style='color:#ffffff'>66</span></li>");
	document.write("		<li class='rig'>&nbsp;</li>");
	document.write("	</ul>");
	document.write("</div>");
	document.write("<!----------------------------->");
	document.write("<!-- COPYRIGHT MENU End ------->");
	document.write("<!----------------------------->");
}


function dspMainMenu(){
	document.write("<!----------------------------->");
	document.write("<!-- MAIN MENU Start         -->");
	document.write("<!----------------------------->");
	document.write("<div class='sMenu'>");
	document.write("	<ul>");
	document.write("		<li class='s1'>");
	document.write("			<a href='index.jsp' class=''><img src='img/toplogo.gif' alt='�ѱ����°��� ���ͳ� ������������'></a>");
	document.write("		</li>");
	document.write("		<li class='s3' style='margin-top:11px;'>");
	document.write("			<a href='sub02_01.html'>�������� �����ϱ�</a>");
	document.write("			<ul>");
	document.write("				<li><a href='sub02_01.html'><span class='padding5'>�������񽺾ȳ� </span></a></li>");
	document.write("				<li><a href='sub02_02.html'><span class='padding5'>��������?</span></a></li>");
	document.write("                <li><a href='sub02_03.html'><span class='padding5'>����ھȳ���</span></a></li>");
	document.write("                <li><a href='sub02_04.html'><span class='padding5'>����</span></a></li>");
	document.write("                <li><a href='sub02_05.html'><span class='padding5'>���ڼ����̶�?</span></a></li>");
	document.write("                <!--li><a href='#'><span class='padding5'>��ȭ�κ��� ���ڼ���</span></a></li-->");			
	document.write("			</ul>");
	document.write("		</li>");
	document.write("		<li class='s2' style='margin-top:11px;'>");
	document.write("			<a href='sub01.html'> �������� �̿��ϱ�</a>");
	document.write("			<ul>");
	document.write("				<li><a href='ini_certNew.jsp'><span class='padding5'>������ �߱�</span></a></li>");
	document.write("				<li><a href='ini_certRevoke.jsp'><span class='padding5'>������ ���</span></a></li>");
	document.write("				<li><a href='#' onclick='ManageCert();'><span class='padding5'>������ ����</span></a></li>");
	document.write("			</ul>");
	document.write("		</li>");
	document.write("	</ul>");
	document.write("</div>");
	document.write("<div style='height:12px;'></div>");
	document.write("<!----------------------------->");
	document.write("<!-- MAIN MENU End      ------->");
	document.write("<!----------------------------->");
}


	