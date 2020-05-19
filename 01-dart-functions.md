# Functions - Optional and anonymous parameters

```dart
void main() {
  createBtn("Click me", "#d80000", 40.0);

  // optional
  createBtnOp("Click me", color: "#d80000", width: 40.0);

  // optional with function
  createBtnFn("Click me", createdButton, color: "#d80000", width: 40.0);
  createBtnFn("Click me", () {
    print("Create button by anonymous function");
  });
}

void createdButton() {
  print("new Button created");
}

// Normal function
void createBtn(String text, String color, double width) {
  print(text);
  print(color);
  print(width);
}

// Optional parameters
void createBtnOp(String text, {String color, double width}) {
  print(text);
  print(color ?? "#000");
  print(width ?? 35.0);
}

// Function as parameters
void createBtnFn(String text, Function createFunc, {String color, double width}) {
  print(text);
  print(color ?? "#000");
  print(width ?? 35.0);
  createFunc();
}
```
