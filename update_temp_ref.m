tr=get(temp_ref_val,'String');
tr_ch=char(tr);
tr_a=double(tr_ch);
message=string(tr_a);
global mqClient;
topicToWrite = "temp_control/temp_ref";
write(mqClient,topicToWrite,tr);
set(temp_ref_val,'String',tr);