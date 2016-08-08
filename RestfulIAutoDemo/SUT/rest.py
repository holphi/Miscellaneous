'''

@Author:	Alex LI

@History:
2016/08/07	First Draft. Implement Restful server.

'''

import sys, os, re
from collections import OrderedDict
from bottle import route, run, template, error, get, post, put, request
from business import Task, TaskManager

task_mgr = TaskManager()

@get('/')
def index():
    return 'Restful server is up!'

@get('/ToDo/Tasks/<task_id>')
def getTask(task_id):
    try:
        task = task_mgr.getTask(task_id)
        if task is not None:
            return {'status': 1,
                'result': [OrderedDict([('id', task.id),
                                        ('title', task.title),
                                        ('description', task.description)])]
               }
        else:
            return {'status': 0,
                'result': 'Empty result returned.'
                }
    except Exception, ex:
        return {'exception': ex}
        
@get('/ToDo/Tasks/')
def getTasks():
    try:
        tasks = task_mgr.getTasks()
        if tasks is not None:
            task_lst = []
            for task in tasks:
                task_lst.append(OrderedDict([('id', task.id), ('title', task.title), ('description', task.description)]))
            return {'status': 1, 'result': task_lst}
        else:
            return {'status' : 0,
                    'result': 'Empty result returned.'}
    except Exception, ex:
        return {'exception': ex}

@post('/ToDo/Tasks/')
def addTask():
    try:
        data = request.json
        status_code = task_mgr.addTask(data.get('id'), data.get('title'), data.get('description'))
        return {'status': status_code, 'result': 'New task has been created.' if status_code==1 else 'Insertion failure. The task id might be duplicated.'}
    except Exception, ex:
        return {'exception': ex}

if __name__=='__main__':
    run(host='0.0.0.0', port='9527', debug=True)