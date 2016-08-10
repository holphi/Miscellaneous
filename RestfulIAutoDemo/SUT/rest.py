'''
@Author:	Alex LI

@History:
2016/08/07	First Draft. Implement Restful server.
2016/08/08  Add routes to update tasks & delete tasks.
2016/08/09  Fix unicode-encoding issue in addTaskMethod, use json.loads to convert json object to dict type

'''

import sys, os, re, json
from collections import OrderedDict
from bottle import route, run, template, error, get, post, put, delete, request
from business import Task, TaskManager

task_mgr = TaskManager()

@get('/')
def index():
    return 'Restful server is up!'

@get('/ToDo/Tasks/<task_id>/')
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
        data = json.loads(request.json)
        #Add function str to convert the coding to ANSI if the coding is UTF-8
        status_code = task_mgr.addTask(str(data['id']), str(data['title']), str(data['description']))
        return {'status': status_code, 'result': 'New task has been created.' if status_code==1 else 'Insertion failure. The task id might be duplicated.'}
    except Exception, ex:
        return {'exception': ex}

@delete('/ToDo/Tasks/<task_id>/')
def deleteTask(task_id):
    try:
        status_code = task_mgr.deleteTask(task_id)
        return {'status': status_code, 'result': 'The task has been removed.' if status_code==1 else 'Operation failure. Invalid Task ID might be provided.'}
    except Exception, ex:
        return {'exception', ex}

@put('/ToDo/Tasks/<task_id>/')
def updateTask(task_id):
    try:
        data = json.loads(request.json)
        status_code = task_mgr.updateTask(task_id, str(data['title']), str(data['description']))
        return {'status': status_code, 'result': 'The task has been updated.' if status_code==1 else 'Update operation failure. Invalid Task ID might be provided.'}
    except Exception, ex:
        return {'exception': ex}

if __name__=='__main__':
    run(host='0.0.0.0', port='9527', debug=True)