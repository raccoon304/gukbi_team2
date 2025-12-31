



$(function(){
	//테이블의 행을 클릭하면 클릭한 정보의대표값(seq)을 제품상세페이지에 보내주기
	$("tbody > tr").click((e) => {
		const seq = $(e.target).parent().find("span").text();
		console.log(seq);
		
		const frm = document.seqFrm;
		frm.seq.value = seq;
		frm.action = "productDetail.hp";
		frm.submit();
	});
	
	
});//and of $(function(){})-----