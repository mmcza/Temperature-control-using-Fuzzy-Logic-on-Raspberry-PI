close all; clear variables; clc; warning off;

%% MQTT
clientID = "Matlab";
%brokerAddress = "mqtt://192.168.0.236";
%brokerAddress = "mqtt://192.168.0.234";
brokerAddress = "mqtt://192.168.43.136";
%brokerAddress = "mqtt://192.168.0.14";

port = 1883;
global mqClient;
mqClient = mqttclient(brokerAddress, Port = port, ClientID = clientID, KeepAliveDuration = hours(24));
mqClient.Connected;

%topicToSub = "matlab/current_temp";
topicToSub1 = "temp_control/current_temp";
topicToSub2 = "temp_control/current_uh";
topicToSub3 = "temp_control/current_uc";
subscribe(mqClient, topicToSub1);
subscribe(mqClient, topicToSub2);
subscribe(mqClient, topicToSub3);

%% Aplikacja okienkowa

%okno
window = figure('Position', [250, 50, 800, 600]);
set(window, 'Name', ['Temperature control application'],'Resize', 'off');

%wykres
ax = uiaxes(window);
ax.Position = [50, 100, 700, 400];
ax.XLabel.String = 'Czas';
ax.YLabel.String = 'Temperatura (°C)';
ax.Title.String = 'Przebieg temperatury';  %ustawienie tła i osi

%pole do wpisania wartosci zadanej
temp_ref=22; %przypisanie wartości domyślnej
temp_ref_tekst=uicontrol('Style', 'text','String','Temperatura zadana',...
    'Position',[300, 525, 150, 20],'FontSize',10);
temp_ref_val = uicontrol('Style', 'edit', 'Position', [450, 525, 50, 20], ...
          'String', temp_ref, 'FontSize', 10, 'Visible','on','Callback','update_temp_ref');

% wyswietlanie grzania i chlodzenia
chlodzenie="Obecny poziom chlodzenia: 0"; %przypisanie wartości domyślnej
chlodzenie_tekst=uicontrol('Style', 'text','String',chlodzenie,'Position',[50, 50, 300, 20],'FontSize',10);
grzanie="Obecny poziom grzania: 0"; %przypisanie wartości domyślnej
grzanie_tekst=uicontrol('Style', 'text','String',grzanie,'Position',[450, 50, 300, 20],'FontSize',10);

%% odczytywanie danych i aktualizacja aplikacji

timestamps = [];
temperature = [];
temp_ref_arr = [];

while 1
    msg = read(mqClient);
    if ~isempty(msg)
        temp_index=find(msg.Topic=="temp_control/current_temp");
        if ~isempty(temp_index)
            temperature(end+1)=ascii2str(msg.Data(temp_index));
            timestamps = [timestamps; msg.Time(temp_index)];
            temp_ref_arr(end+1) = str2double(get(temp_ref_val,'String'));
            if size(temperature,2)<181
                plot(ax,timestamps,temp_ref_arr,'r',timestamps,temperature, 'b');
            else
                plot(ax,timestamps((end-180):end),temp_ref_arr((end-180):end),'r',timestamps((end-180):end),temperature((end-180):end), 'b'); %tu zmieniłem
            end
        end
        uh_index=find(msg.Topic=="temp_control/current_uh");
        if ~isempty(uh_index)
            cur_uh=ascii2str(msg.Data(uh_index));
            grzanie="Obecny poziom grzania: "+cur_uh;
            set(grzanie_tekst,'String', grzanie);
        end
        uc_index=find(msg.Topic=="temp_control/current_uc");
        if ~isempty(uc_index)
            cur_uc=ascii2str(msg.Data(uc_index));
            chlodzenie="Obecny poziom chlodzenia: "+cur_uc;
            set(chlodzenie_tekst,'String', chlodzenie);
        end
    end
end

%% funkcje
function [val]=ascii2str(ascii_str)
a=split(ascii_str);
a_T=nonzeros(str2double(a'));
a_T=a_T(~isnan(a_T))';
val=convertCharsToStrings(char(a_T));    
end