close all
figure(1)
hold on
plot(1/2*gaussmf(1:600,[50 200]),'g')
plot(1/2*gaussmf(1:600,[50 400]),'r')
% ylim([0 1])
%set(gca,'YTick',0:0.2:1)
% hold off
% 
% figure(2)
hold on
plot(9/10*gaussmf(1:600,[50 200]),'--g')
plot(1/10*gaussmf(1:600,[50 400]),'--r')
ylim([0 1])
ylabel('P(T|I)')
xlabel('Feature space')
set(gca,'YTick',0:0.2:1)
set(gca,'XTickLabel',[])
hold off