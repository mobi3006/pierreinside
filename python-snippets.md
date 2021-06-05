# Python Snippets

Lose Sammlung von Snippets ... vor dem Hintergrund, daß ich Jahrzehnte Java programmiert habe.

---

## Reflection mit Function-Pointers

```python
def function1(indentation="   "):
    print(f"{indentation}function1")
def function2(indentation="   "):
    print(f"{indentation}function2")
def function3(indentation="   "):
    print(f"{indentation}function3")
def function4(indentation="   "):
    print(f"{indentation}function4")

def function_list(indentation="   "):
    for func in [function1, function2, function3, function4 ]:
        func(indentation)
```

---

## Reflection auf einer Instanz

```python
class Executor:

    def __init__(self,
                indentation="   "):
        self.indentation = indentation

    def method1(self):
        print(f"{self.indentation}method1")
    def method2(self):
        print(f"{self.indentation}method2")
    def method3(self):
        print(f"{self.indentation}method3")
    def method4(self):
        print(f"{self.indentation}method4")

def straight_forward(executor: Executor):
    executor.method1()
    executor.method2()
    executor.method3()
    executor.method4()

def method_list(executor: Executor):
    for method in ["method1", "method2", "method3", "method4"]:
        class_method = getattr(executor, f"{method}")
        class_method()

print("straight_forward:")
straight_forward(Executor())

print("method_list:")
method_list(Executor())
```
