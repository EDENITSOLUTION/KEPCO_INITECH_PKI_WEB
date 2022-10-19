//���� ��Ʈ ����� ������ ���� ����
var currentFontSize ;
var currentFontSize01 ;
var currentFontSize02 ;
var currentFontSize03 ;
var currentFontSize04 ;
var currentFontSize05 ;

//������ �غ�Ǿ����� �̺�Ʈ�� �ɾ��ش�.
$(document).ready(init);

//�ʱ�ȭ
function init()
{
	// ũ��, �۰� ��ũ�� �̺�Ʈ�� �ɾ��ݴϴ�.
	$(".font_size").click(clickHandler);
}

//ũ��, �۰� ��ũ�� Ŭ���Ǿ����� ó���ϴ� �Լ�
function clickHandler(e)
{
	//�̺�Ʈ ���ĸ� ���´�.
	e.preventDefault(); 
	
	//ũ��, �۰� �� ������� Ŭ���Ǿ����� �Ǻ�
	var whichClicked = $(this).attr("id");
	
	//������ ��Ʈ ����� ���� ������ �����Ѵ�.
	currentFontSize = parseInt($(".view_cont").css("font-size"));
	currentFontSize01 = parseInt($(".view_cont dt").css("font-size"));
	currentFontSize02 = parseInt($(".view_cont dd").css("font-size"));		
	
	//Ŭ���� ��ũ�� ���� ��Ʈ�� ũ�� Ȥ�� �۰� �����մϴ�.
	switch(whichClicked)
	{
		case "larger" :
			//1��Ʈ ũ���Ѵ�.
			setFontSize(1) ;
		break ;
		
		case "smaller" :
			//1��Ʈ �۰��Ѵ�.
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