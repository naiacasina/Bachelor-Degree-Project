
% to filter GSM stimulation
% Naia Ormaza Zulueta 05/2019
%function filtered_GSM_data = GSM_filter_el(data, vector_GSMstimulation)
function filtered_GSM_data = GSM_filter_elW(data, vector_GSMstimulation, el_ref, param) 

s=param.Typefilter;

if s==1,
    filtered_GSM_data = Stopband_filter(data, vector_GSMstimulation,param); % Ancien filtre de Daniela
elseif s==2,
    filtered_GSM_data = GSMfilter(data, el_ref,param); % Naia : Wiener
elseif s==3,
    filtered_GSM_data = rls_filter_2(el_ref,data,param); % Naia : RLS 
end



