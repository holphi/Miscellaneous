class Task:
    def __init__(self, id, title, description):
        self.id = id.strip('\n')
        self.title = title.strip('\n')
        self.description = description.strip('\n')

class TaskManager:
    
    def __init__(self):
        print 'Task mamager initialized...'
        self.__taskfile = './data/tasks.dat'
        
    def getTask(self, id):
        try:
            fh = open(self.__taskfile, 'r')
            for data_line in fh.readlines():
                task_info = data_line.split(':')
                if task_info[0] == id:
                    # Return data
                    return Task(task_info[0], task_info[1], task_info[2])
            return None
        except Exception, e:
            raise e
        finally:
            fh.close()
    
    def getTasks(self):
        try:
            tasks = []
            fh = open(self.__taskfile, 'r')
            for data_line in fh.readlines():
                task_info = data_line.split(':')
                tasks.append(Task(task_info[0], task_info[1], task_info[2]))
            return tasks
        except Exception, e:
            raise e
        finally:
            fh.close()

    #Update task instance, 0: failure, 1: success
    def updateTask(self, id, title, description):
        try:
            if self.getTask(id)==None:
                return 0
            #Retrieve task instance and update
            task_lst=self.getTasks();
            for task in task_lst:
                if(task.id==id):
                    task.title = title
                    task.description = description
            # Remvoe original tasks file
            self.__removeTasksFile()
            # Persist updated tasks to file
            return self.__writeTasksToFile(task_lst)
        except Exception, e:
            raise e

    def __removeTasksFile(self):
        try:
            import os
            if os.path.exists(self.__taskfile):
                os.remove(self.__taskfile)
        except Exception, e:
            raise e
    
    def __writeTasksToFile(self, task_lst):
        try:
            if task_lst is None:
                return 0
            tasks_data = []
            for task in task_lst:
                tasks_data.append('%s:%s:%s\n' % (task.id, task.title, task.description))
            fh = open(self.__taskfile, 'w')
            fh.writelines(tasks_data)
            return 1
        except Exception, e:
            raise e
        finally:
            fh.close()
    
    def addTask(self, id, title, description):
        try:
            if self.getTask(id) is not None:
                return 0
            task = Task(id, title, description)
            task_lst = self.getTasks()
            task_lst.append(task)
            # Remvoe original tasks file
            self.__removeTasksFile()
            # Persist updated tasks to file
            return self.__writeTasksToFile(task_lst)
        except Exception, ex:
            raise ex

    def deleteTask(self, id):
        try:
            task_lst = self.getTasks()
            i=0
            tasks_updated = False
            while(i<len(task_lst)):
                if task_lst[i].id==id:
                    del task_lst[i]
                    tasks_updated = True
                    break
                else:
                    i+=1
                        # Remvoe original tasks file
            if tasks_updated==True:
                self.__removeTasksFile()
                # Persist updated tasks to file
                return self.__writeTasksToFile(task_lst)
            else:
                return 0
        except Exception, ex:
            raise ex