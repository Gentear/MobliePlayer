var fileForm = new Object();
function checkFileSize(fileObj) {
if(fileObj.value != "") {
var form = document.forms['upfile_form'];

//把form的原始数据缓存起来
fileForm.f = form;
fileForm.a = form.getAttribute("action"); //form.action 为一个静态的对象，所以这里要使用getAttribute方法取值
fileForm.t = form.target;

//请求服务器端
form.target = "check_file_frame";
form.action = "./ajax.php?act=upload";
//form.submit(); 其实上面的action已经会执行submit操作，这步可有可无
}
return false;
}

function ajax_callback(result) {
//还原form属性
fileForm.f.target = fileForm.t;
fileForm.f.setAttribute("action", fileForm.a);

//处理结果
switch(result) {
case 0:
alert("文件超过了200K或者没有选择文件，请重新上传！");
//todo somthing
default :
alert("合法");
//do somthing，如果你想使用这种方法实现真正的上传的话，那么在成功后把返回的文件路经存储在一个 input[hidden]里是个不错的办法
}
return ;
}