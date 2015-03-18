% ������� ������������� � ������������ (� ��������) ������������ ������
fs = 16000;
len = fs;
% ����, ��� ����������� ��������� � ������ � ����� �����
w = window(@rectwin, len); % rectwin ��� hann

% ��������� ������������� ������������������ �������
F0 = 100:100:5000;
% A = 1./(1:numel(F0));
A  = ones(size(F0));
Phi= (1:numel(F0))*2*pi/numel(F0);
y = sum(polyharm(fs, len, F0, A, Phi),2);
wavwrite(y.*w*0.95/max(abs(y)), fs, 'phase_test_stat.wav');

% ��������� ������������������ �������, � ������� ��������������� ��������
% �������� �� 100 �� 120 ��
% F0 = linspace(100,120,len)'*(1:size(A,2));
% y = sum(polyharm(fs, len, F0, A, Phi),2);
% wavwrite(y.*w*0.95/max(abs(y)), fs, 'phase_test_flow.wav');



%% ������� ��� ������� �������
F0 =199.0;
Kk = 2;
lp_fc = 10;
lp_ord = 0.5;
b = fir1(round(lp_ord*fs), lp_fc*2/fs);

% ����������� � ����������
z_sz = fix(numel(b)/2);
yz = [y; zeros(z_sz,1)];
tz = (0:size(yz)-1)'/fs;
y1 = filter(b,1, yz.*sin(2*pi*F0*tz));
y2 = filter(b,1, yz.*sin(2*pi*F0*Kk*tz));

% ����������� ��������� �������� �������
tz(end-z_sz+1:end) = [];
y1(1:z_sz) = [];
y2(1:z_sz) = [];

% ����������� ����������
figure('Units','normalized', 'Position',[0 0 1 1]);

subplot(2,2,1);
plot(tz,y1,'b', tz,y2,'r', tz,y1-y2,'k');
legend({'Y1' 'Y2', 'Y1-Y2'},'Location','SE');
grid('on');
title(['F0=' num2str(F0) '��; Kk=' num2str(Kk) '; Fs=' num2str(fs) '��; LP FIR fc=' num2str(lp_fc) '��; LP FIR order=' num2str(numel(b)) ';']);

h1 = hilbert(y1);
h2 = hilbert(y2);
subplot(2,2,2);
plot(tz,abs(h1),'b', tz,abs(h2),'r');
legend({'Y1' 'Y2'},'Location','SW');
grid('on');
ylim(quantile([abs(h1); abs(h2)],[0.01 0.99]));
title('abs(hilbert(Y))');

subplot(2,2,3);
a1 = unwrap(angle(h1));
a2 = unwrap(angle(h2));
plot(tz,a1,'b', tz,a2,'r');
legend({'Y1' 'Y2'},'Location','SE');
grid('on');
title('unwrap(angle(hilbert(Y)))');

subplot(2,2,4);
plot(tz(1:end-1),diff(a1)*fs,'b', tz(1:end-1),diff(a2)*fs,'r');
legend({'Y1' 'Y2'},'Location','SW');
grid('on');
title('diff(unwrap(angle(hilbert(Y))))/dt');
ylim(quantile([diff(a1); diff(a2)]*fs,[0.01 0.99]));

