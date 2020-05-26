%% Goal-Based Probabilistic Foam for Path Planning
%%
clear;
clc;
figure(2);
clf('reset');
%xlabel ('X'); ylabel ('Y')

figure(1);
clf('reset');

K = 4;
bias=0.25;
R = 0.2;

init = [-15, -15];
goal = [15,-15];
[N circles E V ] = A_mapa00(init,goal, 2);


%% ---------------- START -------------
%%
paths = [];
bolhas = [];
tempos = [];
      
ConjObstaculos{2}= N; %Vertices;

vet_pai = []; %local no fila_pontos repectivo ao pai
fila_pontos{1} = init; %primeiro ponto na fila
contador_resultados =1; %n�mero de bolhas analisadas
raio = [eucl_dist(init, nearest_point(ConjObstaculos, circles, init))]; %armazenamento do raio de cada bolha

circle2(init,raio(1));

resultado_encontrado = 0; %sinal bin�rio definindo se o caminho foi encontrado
tic;
while resultado_encontrado==0  

    if (rand <= bias)
        rx = goal(1);
        ry = goal(2);
    else
        [rx,ry] = xrand(ConjObstaculos);
    end
      
    % obtem o ponto mais pr�ximo de r
    dists = [1];
    for ii=1:length(fila_pontos) % Analisando os pontos da espuma
        dists(ii) = eucl_dist(fila_pontos{ii},[rx,ry]);
    end
    [valor posicao] = min(dists);
    
    bm = fila_pontos{posicao};
    
    % https://math.stackexchange.com/questions/127613/closest-point-on-circle-edge-from-point-outside-inside-the-circle
    p_x = bm(1)+ raio(posicao)* ((rx-bm(1))/ sqrt( (rx-bm(1))^2 + (ry-bm(2))^2 ));
    p_y = bm(2)+ raio(posicao)* ((ry-bm(2))/ sqrt( (rx-bm(1))^2 + (ry-bm(2))^2 ));
    
    
    contIntersecao = 0;
    for cntIntersec=length(fila_pontos):-1:1
       if ~(fila_pontos{cntIntersec} == bm)
          if eucl_dist(fila_pontos{cntIntersec}, [p_x p_y]) < raio(cntIntersec)
            contIntersecao = contIntersecao+1;
          end
       end
    end
    
    if (contIntersecao == 0)
        ponto_estimado = [p_x p_y];
        pontoMaisProximo_aux = nearest_point (ConjObstaculos, circles, ponto_estimado); %ponto mais proximo dos obs        
        raio_circulo_aux = eucl_dist(ponto_estimado,pontoMaisProximo_aux); %
        
        if (raio_circulo_aux >= R) 
            
            plot(rx,ry,'.','color','r');  
            contador_resultados = contador_resultados+1; % Incrementa pois achou um novo resultado
            
            vet_pai{contador_resultados} = posicao; % Salva posicao do pai
            fila_pontos{contador_resultados} = ponto_estimado; % salva novo ponto na posição atual
            raio = [raio;raio_circulo_aux];

            circle2(ponto_estimado,raio_circulo_aux);
            pause(0.05)  
            if(eucl_dist(goal,ponto_estimado)<=raio_circulo_aux)
                resultado_encontrado=1; %caminho encontrado
                tempos = [tempos toc]
                break;
            end
        end
    end    

end

num_auxiliar = contador_resultados;

caminho = [];
raios = [];

if(resultado_encontrado==1)
    while(num_auxiliar>1) %obter caminho resultando pelo grau de parentesco
        caminho = [caminho,fila_pontos{num_auxiliar}'];
        raios = [raios;raio(num_auxiliar)];
       %%  circle2(fila_pontos{num_auxiliar},raio(num_auxiliar));
        num_auxiliar = vet_pai{num_auxiliar};
    end
    caminho = [goal',caminho,init'];    
     %line(caminho(1,:),caminho(2,:),'LineWidth',3,'color', 'green');
    
    plot(init(1),init(2),'o','color',[0 0.5 0],'MarkerFaceColor',[0 0.5 0]);
    plot(goal(1),goal(2),'o','color','b','MarkerFaceColor','b');
    figure(2)
     
    for (i=2:length(caminho(1,:)))
        circle2(caminho(:,i),eucl_dist(caminho(:,i),nearest_point (ConjObstaculos,circles, caminho(:,i))));
    end
    circle2(init,raio(1));
    line(caminho(1,:),caminho(2,:),'LineWidth',2,'color', 'red');
    plot(init(1),init(2),'o','color',[0 0.5 0],'MarkerFaceColor',[0 0.5 0]);
    plot(goal(1),goal(2),'o','color','b','MarkerFaceColor','b');
    
end

path = [];
for i=1:length(caminho)-1
    path = [path; eucl_dist(caminho(:, i), caminho(:, i+1))];
end
paths = [paths sum(path)]

% mean(bolhas)
% std(bolhas)
% mean(tempos)
% std(tempos)
% mean(paths)
% std(paths)
% distanciaEspuma = [distanciaEspuma, sum(path)];