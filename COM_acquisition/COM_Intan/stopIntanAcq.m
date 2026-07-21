function stopIntanAcq

global IcomState

%fwrite(IcomState.msg, 'stop')
write(IcomState,'stop')