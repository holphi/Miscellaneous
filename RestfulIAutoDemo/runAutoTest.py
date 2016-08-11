import json, xlrd
from xlutils.copy import copy

default_host = 'http://localhost:9527'

test_cases_file = 'testcases.xls'

class TestCase():

    def __init__(self, id, title, request_path, method, request_body, expected_response):
        self.id = id
        self.title = title
        self.request_path = request_path
        self.method = method.upper()
        self.request_body = request_body
        self.expected_response = expected_response
        self.result = 'UNEXECUTED'
        self.actual_response = ''
        self.error_message = ''

    def __str__(self):
        return "ID:%-15s TITLE:%-55s REQUEST_PATH:%-20s METHOD:%-10s RESULT:%-15s" % (self.id, self.title, self.request_path, self.method, self.result)

def retrieve_test_cases():
    wb = xlrd.open_workbook(test_cases_file)
    sh = wb.sheet_by_index(0)
    result = []
    for rownum in range(1, sh.nrows):
        row_data = sh.row_values(rownum)
        result.append(TestCase(row_data[0], row_data[1], row_data[2], row_data[3],
                               row_data[4], row_data[5]))
    #Return TC list
    return result

def log_test_result(tc_list):
    import xlwt
    
    wb = copy(xlrd.open_workbook(test_cases_file, formatting_info=True))
    ws=wb.get_sheet(0)
    test_result_col = 6
    actual_result_col = 7
    row = 1

    #Pre-defined styles
    
    #Font
    font = xlwt.Font()
    font.bold = True

    #Borders
    borders = xlwt.Borders()
    borders.left = xlwt.Borders.THIN
    borders.right = xlwt.Borders.THIN
    borders.top = xlwt.Borders.THIN
    borders.bottom = xlwt.Borders.THIN
    
    result_style = xlwt.XFStyle()
    result_style.font = font
    result_style.borders = borders

    actual_result_style = xlwt.XFStyle()
    actual_result_style.borders = borders

    for tc in tc_list:
        ws.write(row, test_result_col, tc.result, result_style)         
        ws.write(row, actual_result_col, tc.actual_result, actual_result_style)
        row+=1
       
    wb.save('test_result.xls')

def run_test(test_case_inst):
    import requests
    
    # Compose access URL to be tested
    access_url = default_host + test_case_inst.request_path

    # Create request object according to request verb, by default, a get request will be created.
    if test_case_inst.method=='' or test_case_inst.method=='GET':
        r = requests.get(access_url)
    if test_case_inst.method == 'POST':
        headers = {'content-type': 'application/json'}
        payload = json.dumps(test_case_inst.request_body)
        r = requests.post(access_url, headers=headers, data=payload)
    if test_case_inst.method == 'DELETE':
        r = requests.delete(access_url)
    if test_case_inst.method == 'PUT':
        headers = {'content-type': 'application/json'}
        payload = json.dumps(test_case_inst.request_body)
        r = requests.put(access_url, headers=headers, data=payload)

    # If incorrect response returned, then log an error
    if r.status_code != 200:
        test_case_inst.result = 'ERROR'
        test_case_inst.error_message = 'Incorrect status code %d returned.' % r.status_code
        return

    test_case_inst.actual_result = json.dumps(r.json())

    try:
        expected_result = eval(test_case_inst.expected_response)
        if type(expected_result)!=dict:
            raise Exception('Expected result cannot be parsed to dict type.')
    except Exception, ex:
        test_case_inst.result = 'ERROR'
        test_case_inst.error_message = ex.message

    # If there's any error happening before comparing test result, then quit this method
    if test_case_inst.result=='ERROR':
        print test_case_inst
        return

    # Verification - Compare JSON objects
    encoded_json_expected = json.dumps(eval(test_case_inst.expected_response), sort_keys=True)
    encoded_json_actual = json.dumps(r.json(), sort_keys=True)
    
    if(encoded_json_expected==encoded_json_actual):
        test_case_inst.result = 'PASS'
    else:
        test_case_inst.result = 'FAIL'
    print test_case_inst
    
def main():
    print '\nDefault Host: %s \n' % default_host
    tc_list = retrieve_test_cases()
    print 'Number of test cases: %d \n' % len(tc_list)
    print 'Executing test cases.\n'
    for TC in tc_list:
        run_test(TC)
    print '\nWriting test result to xls file...\n'
    log_test_result(tc_list)
    print '\nDone. Please check the test report for detail'

if __name__=='__main__':
    main()