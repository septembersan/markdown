import numpy as np
import random
from enum import Enum
import numpy as np
import matplotlib.pyplot as plt


STATUS_NUM = 15
LAYER_NUM = 4
EPSILON = 0.3
GENELATION = 10000
GOAL = 9
ALPHA = 0.1
GAMMA = 0.9
class Direction(Enum):
    LEFT = 0
    RIGHT = 1

class Tree():
    def __init__(self, nodeNum, layerNum):
        self.tree = list()
        for i in range(layerNum):
            nodeNumInLayer = (2) ** i
            for j in range(nodeNumInLayer):
                self.tree.append(Status(len(self.tree), i))

    def dispTree(self):
        for st in self.tree:
            print(st.qvalue())
    def getStatusMaxQvalue(self, st):
        # 0: left
        # 1: right
        rightQv = self.tree[st.rightIdx()].qvalue()
        leftQv = self.tree[st.leftIdx()].qvalue()
        if rightQv < leftQv:
            return self.tree[st.leftIdx()]
        else:
            return self.tree[st.rightIdx()]
    def selectDirection(self, st):
        if ((st.stIdx() * 2) + 1) >= STATUS_NUM:
            return st
        # prevent not to select same status always
        if random.uniform(0.1, 1.0) < EPSILON:
            if random.randint(0, 1) == Direction.LEFT:
                # selected left
                return self.tree[st.leftIdx()]
            else:
                # selected right
                return self.tree[st.rightIdx()]
        else:
            return self.getStatusMaxQvalue(st)
    def updateQvalue(self, st):
        # bottom status in tree
        if (st.layerNum() + 1) >= LAYER_NUM:
            if GOAL == st.stIdx():
                st.setQvalue(st.qvalue() + ALPHA * (1000 - st.qvalue()))
        else:
            maxQvalue = self.getStatusMaxQvalue(st).qvalue()
            st.setQvalue(st.qvalue() + ALPHA * (GAMMA * maxQvalue - st.qvalue()))
    def printQvalue(self):
        for st in self.tree:
            print('%.0f' % st.qvalue(), end="")
            print(", ", end="")
        print("")

    #  def calcLayerNum(self):
    #      if STATUS_NUM < 1:
    #          return 0
    #      temp = STATUS_NUM
    #      count = 1
    #      while True:
    #          temp = temp / 2
    #          if 1 >= temp:
    #              break
    #          count++
    #      return count
    def action(self):
        #  calcLayerNum()
        for i in range(GENELATION):
            st = self.tree[0]
            for j in range(LAYER_NUM):
                st = self.selectDirection(st)
                self.updateQvalue(st)
            self.printQvalue()

class Status():
    def __init__(self, stIdx, layerNum):
        self._stIdx = stIdx
        self._layerNum = layerNum
        self._rightIdx = (stIdx * 2) + 1
        self._leftIdx = (stIdx * 2) + 2
        # init qvalue
        self._qvalue = random.randint(0, 100)
    def rightIdx(self):
        return self._rightIdx
    def leftIdx(self):
        return self._leftIdx
    def qvalue(self):
        return self._qvalue
    def setQvalue(self, qvalue):
        self._qvalue = qvalue
    def stIdx(self):
        return self._stIdx
    def layerNum(self):
        return self._layerNum

if __name__=='__main__':
    tree = Tree(STATUS_NUM, LAYER_NUM)
    tree.action()

