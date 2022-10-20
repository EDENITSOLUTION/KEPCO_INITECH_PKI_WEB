//현재 폰트 사이즈를 저장할 전역 변수
var currentFontSize ;
var currentFontSize01 ;
var currentFontSize02 ;
var currentFontSize03 ;
var currentFontSize04 ;
var currentFontSize05 ;

//문서가 준비되었는지 이벤트를 걸어준다.
$(document).ready(init);

//초기화
function init()
{
	// 크게, 작게 링크에 이벤트를 걸어줍니다.
	$(".font_size").click(clickHandler);
}

//크게, 작게 링크가 클릭되었을때 처리하는 함수
function clickHandler(e)
{
	//이벤트 전파를 막는다.
	e.preventDefault(); 
	
	//크게, 작게 중 어느것이 클릭되었는지 판별
	var whichClicked = $(this).attr("id");
	
	//현재의 폰트 사이즈를 전역 변수에 저장한다.
	currentFontSize = parseInt($(".view_cont").css("font-size"));
	currentFontSize01 = parseInt($(".view_cont dt").css("font-size"));
	currentFontSize02 = parseInt($(".view_cont dd").css("font-size"));		
	
	//클릭된 링크에 따라 폰트를 크게 혹은 작게 설정합니다.
	switch(whichClicked)
	{
		case "larger" :
			//1폰트 크게한다.
			setFontSize(1) ;
		break ;
		
		case "smaller" :
			//1폰트 작게한다.
			setFontSize(-1) ;
		break ;
	}
}

function setFontSize($size)
{	
	var totalFontSize = currentFontSize + $size ;
	var totalFontSize01 = currentFontSize01 + $size ;
	var totalFontSize02 = currentFontSize02 + $size ;	
	$(".view_cont").css({"font-size":totalFontSize+"px"});
	$(".view_cont dt").css({"font-size":totalFontSize01+"px"});
	$(".view_cont dd").css({"font-size":totalFontSize02+"px"});
}