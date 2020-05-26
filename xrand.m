%fill([7.5 20 20 7.5],[-5 -5 7.5 7.5],'b')
%fill([-5 7.5 7.5 -5],[-5 -5 7.5 7.5],'y')
%fill([-5 7.5 7.5 -5],[7.5 7.5 20 20],'m')
%fill([7.5 7.5 20 20], [7.5 20 20 7.5],'g')

% Gera pontos dentro de C_Livre

function [rx,ry] = xrand(ConjObstaculos)
    a = -20;
    b = 20;
    %inObs = [1];
    %while sum(inObs)>0
        rx = (b-a).*rand + a;
        ry = (b-a).*rand + a;
%         inObs = [];    
%         for i=1:length(ConjObstaculos{2})-1
%             inObs = [inObs inpolygon(rx,ry, ConjObstaculos{2}{i}(:,1), ConjObstaculos{2}{i}(:,2))];
%         end
    %end

    %plot(rx,ry,'.','color','r');
end