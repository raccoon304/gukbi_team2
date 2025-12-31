



$(function(){
	
	$("tbody > tr").click((e) => {
		const seq = $(e.target).parent().find("span").text();
		alert("클릭하셨습니다.", seq);
		
		/*const frm = document.seqFrm;
		frm.seq.value = seq;
		frm.action = "personDetail.do";
		frm.method = "post";
		frm.submit();*/
	});
	
	
});//and of $(function(){})-----