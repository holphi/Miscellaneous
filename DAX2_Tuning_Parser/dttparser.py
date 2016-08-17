COPYRIGHT='''DTT XML Parser for DAX2 DB v3.0

Using this parser, you can retrieve all tuning information which is compatible to the schema of DAX2 DB v3.0

The instance of class TuningDataParser provides below bound methods:

- getIEQBands()
- getGEQBands()
- getProfileEndpointPort()
- getProfileEndpointType()
- getProfileTuning()
- getDeviceEndpoints()
- getDeviceTuning()

(C) 2014 Dolby Laboratories,. All rights reserved.
Author: Alex LI

Revision History:
2016-03-25  First draft
'''

from xml.dom import minidom
import xpath # This package can be get from: https://github.com/neild/py-dom-xpath
from os.path import exists, abspath
from collections import OrderedDict

class TuningDataParser(object):

    def __init__(self, xml_file_path, device_id=None):
        '''Constructor, it receives xml_file_path as the input, raise FileNotFoundError if the xml file doesn't exist'''
        if not exists(abspath(xml_file_path)):
            raise FileNotFoundError("File %s doesn't exist" % xml_file_path)

        self.__xmldoc = minidom.parse(abspath(xml_file_path)).documentElement
        if device_id is not None:
            self.device_id = device_id
        else:
            self.device_id = 'EMPTY'
        
    def getIEQBands(self):
        '''Get all IEQ bands information.'''
        rst_data = []
        for ieqInst in xpath.find('//preset[@type="ieq"]/@id', self.__xmldoc):
            #Pass ieq ID & append the result to the list
            rst_data.append(self.__getIEQRecord(ieqInst.value))
        #return ieq band info
        return rst_data

    def __getIEQRecord(self, ieq_id):
        ieq_record = {}
        frequency_lst = []
        target_lst = []
        for item in xpath.find('//preset[@id=$id]/data/ieq-bands/band_ieq', self.__xmldoc, id=ieq_id):
            frequency_lst.append(item.getAttribute('frequency'))
            target_lst.append(item.getAttribute('target'))
        ieq_record['Device_ID'] = self.device_id
        ieq_record['id'] = ieq_id
        ieq_record['frequency'] = ','.join(frequency_lst)
        ieq_record['target'] = ','.join(target_lst)
        return ieq_record

    def getGEQBands(self):
        '''Get all IEQ bands information'''
        rst_data = []
        for geqInst in xpath.find('//preset[@type="geq"]/@id', self.__xmldoc):
            rst_data.append(self.__getGEQRecord(geqInst.value))
        #return geq band info
        return rst_data

    def __getGEQRecord(self, geq_id):
        geq_record = {}
        frequency_lst = []
        gain_lst = []
        for item in xpath.find('//preset[@id=$id]/data/graphic-equalizer-bands/band_geq', self.__xmldoc, id=geq_id):
            frequency_lst.append(item.getAttribute('frequency'))
            gain_lst.append(item.getAttribute('gain'))
        geq_record['Device_ID'] = self.device_id
        geq_record['id'] = geq_id
        geq_record['frequency'] = ','.join(frequency_lst)
        geq_record['gain'] = ','.join(gain_lst)
        return geq_record

    def __convertBoolToInt(self, dic):
        '''Format value in dictionary, convert boolean to int '''
        for key in dic.keys():
            if dic[key].lower() in ['true', 'false']:
                dic[key] = dic[key]=='true' and '1' or '0'

    def getProfileEndpointPort(self):
        '''Retrieve all profile nodes and get information of EDP ports'''
        rst_data = []
        
        for profile_node in xpath.find('//profile', self.__xmldoc):
            profile_id = profile_node.getAttribute('id')
            profile_name = profile_node.getAttribute('name')
            for edp_port_node in xpath.find('//profile[@id=$id][@name=$nm]/data/endpoint_port', self.__xmldoc, id=profile_id, nm=profile_name):
                edp_port = {}
                edp_port['Device_ID'] = self.device_id
                edp_port['Profile'] = profile_id
                edp_port['Endpoint_Port'] = edp_port_node.getAttribute('id')
                edp_port['volume-leveler-in-target'] = edp_port_node.getElementsByTagName('volume-leveler-in-target')[0].getAttribute('value')
                edp_port['volume-leveler-out-target'] = edp_port_node.getElementsByTagName('volume-leveler-out-target')[0].getAttribute('value')

                self.__convertBoolToInt(edp_port)
                
                rst_data.append(edp_port)
        
        return rst_data

    def getProfileEndpointType(self):
        '''Retrieve all profile nodes and get information of EDP type'''
        rst_data = []
        
        for profile_node in xpath.find('//profile', self.__xmldoc):
            profile_id = profile_node.getAttribute('id')
            profile_name = profile_node.getAttribute('name')            
            for edp_type_node in xpath.find('//profile[@id=$id][@name=$nm]/data/endpoint_type', self.__xmldoc, id=profile_id, nm=profile_name):
                edp_type = {}
                edp_type['Device_ID'] = self.device_id
                edp_type['Profile'] = profile_id
                edp_type['Endpoint_Type'] = edp_type_node.getAttribute('id')
                edp_type['calibration_boost'] = edp_type_node.getElementsByTagName('calibration-boost')[0].getAttribute('value')
                edp_type['dialog_enhancer_enable'] = edp_type_node.getElementsByTagName('dialog-enhancer-enable')[0].getAttribute('value')
                edp_type['dialog_enhancer_amount'] = edp_type_node.getElementsByTagName('dialog-enhancer-amount')[0].getAttribute('value')
                edp_type['dialog_enhancer_ducking'] = edp_type_node.getElementsByTagName('dialog-enhancer-ducking')[0].getAttribute('value')
                edp_type['surround_boost'] = edp_type_node.getElementsByTagName('surround-boost')[0].getAttribute('value')
                edp_type['volmax_boost'] = edp_type_node.getElementsByTagName('volmax-boost')[0].getAttribute('value')
                edp_type['volume_leveler_enable'] = edp_type_node.getElementsByTagName('volume-leveler-enable')[0].getAttribute('value')
                edp_type['volume_leveler_amount'] = edp_type_node.getElementsByTagName('volume-leveler-amount')[0].getAttribute('value')
                edp_type['intermediate_profile_partial_virtualizer_enable'] = edp_type_node.getElementsByTagName('intermediate_profile_partial_virtualizer_enable')[0].getAttribute('value')

                self.__convertBoolToInt(edp_type)
                
                rst_data.append(edp_type)

        return rst_data

    def getProfileTuning(self):
        '''Retrieve profile nodes, get all profile tuning data'''
        rst_data = []
        for profile_node in xpath.find('//profile', self.__xmldoc):
            profile_tuning = {}
            profile_tuning['Device_ID'] = self.device_id
            profile_tuning['id'] = profile_node.getAttribute('id')
            profile_tuning['name'] = profile_node.getAttribute('name')
            
            #Retrieve profile tuning data
            data_node = profile_node.getElementsByTagName('data')[0]
            profile_tuning['graphic_equalizer_enable'] = data_node.getElementsByTagName('graphic-equalizer-enable')[0].getAttribute('value')
            profile_tuning['ieq_enable'] = data_node.getElementsByTagName('ieq-enable')[0].getAttribute('value')
            profile_tuning['ieq_amount'] = data_node.getElementsByTagName('ieq-amount')[0].getAttribute('value')
            profile_tuning['mi_dialog_enhancer_steering_enable'] = data_node.getElementsByTagName('mi-dialog-enhancer-steering-enable')[0].getAttribute('value')
            profile_tuning['mi_dv_leveler_steering_enable'] = data_node.getElementsByTagName('mi-dv-leveler-steering-enable')[0].getAttribute('value') 
            profile_tuning['mi_ieq_steering_enable'] = data_node.getElementsByTagName('mi-ieq-steering-enable')[0].getAttribute('value')
            profile_tuning['mi_surround_compressor_steering_enable'] = data_node.getElementsByTagName('mi-surround-compressor-steering-enable')[0].getAttribute('value')
            profile_tuning['virtualizer_headphone_reverb_gain'] = data_node.getElementsByTagName('virtualizer-headphone-reverb-gain')[0].getAttribute('value')
            profile_tuning['intermediate_profile_audio_optimizer_enable'] = data_node.getElementsByTagName('intermediate_profile_audio-optimizer-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_bass_enhancer_enable'] = data_node.getElementsByTagName('intermediate_profile_bass-enhancer-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_bass_extraction_enable'] = data_node.getElementsByTagName('intermediate_profile_bass-extraction-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_process_optimizer_enable'] = data_node.getElementsByTagName('intermediate_profile_process-optimizer-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_regulator_enable'] = data_node.getElementsByTagName('intermediate_profile_regulator-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_regulator_speaker_dist_enable'] = data_node.getElementsByTagName('intermediate_profile_regulator-speaker-dist-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_surround_decoder_enable'] = data_node.getElementsByTagName('intermediate_profile_surround-decoder-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_volume_modeler_enable'] = data_node.getElementsByTagName('intermediate_profile_volume-modeler-enable')[0].getAttribute('value')
            profile_tuning['intermediate_profile_partial_virtual_bass_enable'] = data_node.getElementsByTagName('intermediate_profile_partial_virtual_bass_enable')[0].getAttribute('value')
            #Retrieve preset value(IEQ and GEQ)
            profile_tuning['ieq_bands'] = profile_node.getElementsByTagName('include')[0].getAttribute('preset')
            profile_tuning['geq_bands'] = profile_node.getElementsByTagName('include')[1].getAttribute('preset')

            #Format values, convert bool value to int value
            self.__convertBoolToInt(profile_tuning);

            #Append profile tuning to the list
            rst_data.append(profile_tuning)
            
        return rst_data

    def getDeviceEndpoints(self):
        '''Retrieve all device endpoints under tuning nodes'''
        rst_data = []
        
        for tuning_node in xpath.find('//tuning', self.__xmldoc):
            for device_node in tuning_node.getElementsByTagName('device_id'):
                edp_device = {}
                edp_device['Device_ID'] = self.device_id
                edp_device['Tuning_Name'] = tuning_node.getAttribute('name')
                edp_device['Endpoint_Port'] = device_node.getAttribute('endpoint_port')
                edp_device['Mode'] = tuning_node.getAttribute('operating_mode')
                edp_device['Description'] = device_node.getAttribute('id')
                rst_data.append(edp_device)
                
        return rst_data

    def getDeviceTuning(self):
        '''Retrieve all tuning data'''
        rst_data = []
        
        for tuning_node in xpath.find('//tuning', self.__xmldoc):
            
            tuning_data = {}
            tuning_data['Device_ID'] = self.device_id
            tuning_data['name'] = tuning_node.getAttribute('name')
            tuning_data['profile_restrictions'] = tuning_node.hasAttribute('profile_restrictions') and tuning_node.getAttribute('profile_restrictions') or 'none'
            tuning_data['classification'] = tuning_node.getAttribute('classification')
            tuning_data['endpoint_type'] = tuning_node.getAttribute('endpoint_type')
            tuning_data['mono_device'] = tuning_node.getAttribute('mono_device')
            tuning_data['has_sub'] = tuning_node.getAttribute('has_sub')
            tuning_data['tuned_rate']= tuning_node.getAttribute('tuned_rate')
            #Reserverd field
            tuning_data['preGain'] = ''
            #Reserverd field
            tuning_data['postGain'] = ''

            #Retrieve tuning parameters under //tuning/data
            self.__processTuningParams(tuning_data['name'], tuning_data['profile_restrictions'], tuning_data)

            #Format values, convert bool value to int value
            self.__convertBoolToInt(tuning_data)

            rst_data.append(tuning_data)

        return rst_data
    
    def __processTuningParams(self, name, profile_restrictions, tuning_data):
        '''Process current tuning node, retrieve tuning data and save to current dictionary passed in'''
        #Audio optimizer: frequency
        params = []
        for property in xpath.find('//tuning[@name=$nm]/data/audio-optimizer-bands/band_optimizer/@frequency', self.__xmldoc, nm=name):
            params.append(property.value)
        tuning_data['audio_optimizer_bands_Frequency'] = ','.join(params)
            
        #Audio optimizer: gain
        gain_lst = ['gain_left', 'gain_right', 'gain_center', 'gain_lfe', 'gain_left_surround',
                    'gain_right_surround', 'gain_left_rear_surround', 'gain_right_rear_surround', 'gain_left_top_middle', 'gain_right_top_middle']
        for i in range(len(gain_lst)):
            params = []
            for property in xpath.find('//tuning[@name=$nm]/data/audio-optimizer-bands/band_optimizer/@%s' % (gain_lst[i]), self.__xmldoc, nm=name):
                params.append(property.value)
            tuning_data['audio_optimizer_bands_Gain%d' % i] = ','.join(params)

        #Process optimizer: frequency
        params = []
        for property in xpath.find('//tuning[@name=$nm]/data/process-optimizer-bands/band_optimizer/@frequency', self.__xmldoc, nm=name):
            params.append(property.value)
        tuning_data['process_optimizer_bands_Frequency'] = ','.join(params)
        #Process optimizer: gain
        for i in range(len(gain_lst)):
            params = []
            for property in xpath.find('//tuning[@name=$nm]/data/process-optimizer-bands/band_optimizer/@%s' % (gain_lst[i]), self.__xmldoc, nm=name):
                params.append(property.value)
            tuning_data['process_optimizer_bands_Gain%d' % i] = ','.join(params)

        #Audio regulator: frequency
        params = []
        for property in xpath.find('//tuning[@name=$nm]/data/regulator-tuning/band_regulator/@frequency', self.__xmldoc, nm=name):
            params.append(property.value)
        tuning_data['audio_regulator_frequency'] = ','.join(params)
        params = []
        for property in xpath.find('//tuning[@name=$nm]/data/regulator-tuning/band_regulator/@threshold_low', self.__xmldoc, nm=name):
            params.append(property.value)
        tuning_data['audio_regulator_threshold_low'] = ','.join(params)
        params = []
        for property in xpath.find('//tuning[@name=$nm]/data/regulator-tuning/band_regulator/@threshold_high', self.__xmldoc, nm=name):
            params.append(property.value)
        tuning_data['audio_regulator_threshold_high'] = ','.join(params)
        params = []
        for property in xpath.find('//tuning[@name=$nm]/data/regulator-tuning/band_regulator/@isolated_band', self.__xmldoc, nm=name):
            params.append(property.value=='true' and '1' or '0')
        tuning_data['audio_regulator_isolated_band'] = ','.join(params)

        #Retrieve other tuning data
        data_node = xpath.find('//tuning[@name=$nm]/data', self.__xmldoc, nm=name)[0]
        tuning_data['bass_enhancer_boost'] = data_node.getElementsByTagName('bass-enhancer-boost')[0].getAttribute('value')
        tuning_data['bass_enhancer_cutoff_frequency'] = data_node.getElementsByTagName('bass-enhancer-cutoff-frequency')[0].getAttribute('value')
        tuning_data['bass_enhancer_width'] = data_node.getElementsByTagName('bass-enhancer-width')[0].getAttribute('value')
        tuning_data['bass_extraction_cutoff_frequency'] = data_node.getElementsByTagName('bass-extraction-cutoff-frequency')[0].getAttribute('value')
        tuning_data['height_filter_mode'] = data_node.getElementsByTagName('height-filter-mode')[0].getAttribute('value')
        tuning_data['regulator_overdrive'] = data_node.getElementsByTagName('regulator-overdrive')[0].getAttribute('value')
        tuning_data['regulator_timbre_preservation'] = data_node.getElementsByTagName('regulator-timbre-preservation')[0].getAttribute('value')
        tuning_data['regulator_relaxation_amount'] = data_node.getElementsByTagName('regulator-relaxation-amount')[0].getAttribute('value')
        tuning_data['virtual_bass_overall_gain'] = data_node.getElementsByTagName('virtual-bass-overall-gain')[0].getAttribute('value')
        tuning_data['virtual_bass_slope_gain'] = data_node.getElementsByTagName('virtual-bass-slope-gain')[0].getAttribute('value')
        tuning_data['virtual_bass_mix_freqs_low'] = data_node.getElementsByTagName('virtual-bass-mix-freqs')[0].getAttribute('frequency_low')
        tuning_data['virtual_bass_mix_freqs_high'] = data_node.getElementsByTagName('virtual-bass-mix-freqs')[0].getAttribute('frequency_high')
        tuning_data['virtual_bass_src_freqs_low'] = data_node.getElementsByTagName('virtual-bass-src-freqs')[0].getAttribute('frequency_low')
        tuning_data['virtual_bass_src_freqs_high'] = data_node.getElementsByTagName('virtual-bass-src-freqs')[0].getAttribute('frequency_high')
        tuning_data['virtual_bass_subgains_num'] = data_node.getElementsByTagName('virtual-bass-subgains')[0].getAttribute('num_gains')
        tuning_data['virtual_bass_subgains_harmonic_2'] = data_node.getElementsByTagName('virtual-bass-subgains')[0].getAttribute('harmonic_2')
        tuning_data['virtual_bass_subgains_harmonic_3'] = data_node.getElementsByTagName('virtual-bass-subgains')[0].getAttribute('harmonic_3')
        tuning_data['virtual_bass_subgains_harmonic_4'] = data_node.getElementsByTagName('virtual-bass-subgains')[0].getAttribute('harmonic_4')
        tuning_data['virtualizer_speaker_angle'] = data_node.getElementsByTagName('virtualizer-speaker-angle')[0].getAttribute('value')
        tuning_data['virtualizer_speaker_start_freq'] = data_node.getElementsByTagName('virtualizer-speaker-start-freq')[0].getAttribute('value')
        tuning_data['virtualizer_front_speaker_angle'] = data_node.getElementsByTagName('virtualizer-front-speaker-angle')[0].getAttribute('value')
        tuning_data['virtualizer_height_speaker_angle'] = data_node.getElementsByTagName('virtualizer-height-speaker-angle')[0].getAttribute('value')
        tuning_data['virtualizer_surround_speaker_angle'] = data_node.getElementsByTagName('virtualizer-surround-speaker-angle')[0].getAttribute('value')
        tuning_data['volume_modeler_calibration'] = data_node.getElementsByTagName('volume-modeler-calibration')[0].getAttribute('value')
        tuning_data['intermediate_tuning_audio_optimizer_enable'] = data_node.getElementsByTagName('intermediate_tuning_audio-optimizer-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_bass_enhancer_enable'] = data_node.getElementsByTagName('intermediate_tuning_bass-enhancer-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_bass_extraction_enable'] = data_node.getElementsByTagName('intermediate_tuning_bass-extraction-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_process_optimizer_enable'] = data_node.getElementsByTagName('intermediate_tuning_process-optimizer-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_regulator_enable'] = data_node.getElementsByTagName('intermediate_tuning_regulator-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_regulator_speaker_dist_enable'] = data_node.getElementsByTagName('intermediate_tuning_regulator-speaker-dist-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_surround_decoder_enable'] = data_node.getElementsByTagName('intermediate_tuning_surround-decoder-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_volume_modeler_enable'] = data_node.getElementsByTagName('intermediate_tuning_volume-modeler-enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_partial_virtual_bass_enable'] = data_node.getElementsByTagName('intermediate_tuning_partial_virtual_bass_enable')[0].getAttribute('value')
        tuning_data['intermediate_tuning_partial_virtual_bass_mode'] = data_node.getElementsByTagName('intermediate_tuning_partial_virtual-bass-mode')[0].getAttribute('value')
        tuning_data['intermediate_tuning_partial_virtualizer_enable'] = data_node.getElementsByTagName('intermediate_tuning_partial_virtualizer_enable')[0].getAttribute('value')

        #Reteive info of partial output mode under data node
        output_channels_node = data_node.getElementsByTagName('intermediate_tuning_partial_output-mode')[0].getElementsByTagName('output_channels')[0]
        tuning_data['intermediate_tuning_partial_output_mode_channels'] = output_channels_node.hasAttribute('value') and output_channels_node.getAttribute('value') or ''
        mix_matrix_node = data_node.getElementsByTagName('intermediate_tuning_partial_output-mode')[0].getElementsByTagName('mix_matrix')[0]
        tuning_data['intermediate_tuning_partial_output_mode_mixmatrix'] = mix_matrix_node.hasAttribute('value')==True and mix_matrix_node.getAttribute('value') or ''


if __name__=='__main__':
    
    dtt_file = TuningDataParser('Headphone_hd_full.xml', '4')
    
    device_tuning = dtt_file.getDeviceTuning()

    print len(device_tuning)
    print '\n'
    
    for record in device_tuning:
        '''([Device_ID], [name], [profile_restrictions]);'''
        print record['Device_ID']
        print record['name']
        print record['profile_restrictions']
        print '\n'''
        

    '''for tuning_data in tuning_data_lst:
        for key in tuning_data.keys():
            print key + ' : ' + tuning_data[key]
    
    for data_item in tuning_data.getIEQBands():
        print '|Device_ID=%s|id=%s|frequency=%s|target=%s|' % (data_item['Device_ID'], data_item['id'], data_item['frequency'], data_item['target'])

    for data_item in tuning_data.getGEQBands():
        print '|Device_ID=%s|id=%s|frequency=%s|gain=%s|' % (data_item['Device_ID'], data_item['id'], data_item['frequency'], data_item['gain'])'''
    
