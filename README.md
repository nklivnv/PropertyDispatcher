# Property Dispatcher/Converter for Godot 4

---

## English

> A set of tools for dynamic property transformation and synchronization between objects in Godot Engine.

### Features

- **PropertyDispatcher** – bind any object property to a node with automatic read/write.
- **PropertyConverter** – apply a `ValueConverter` before writing the value.
- **PropertyConverterStack** – chain multiple converters and write the result to several target properties.
- **Ready ValueConverter resources**:
  - `ValueConverterCurve` – remap floats with a `Curve`.
  - `ValueConverterExpression` – evaluate custom GDScript expressions (access input value and Engine singletons).
  - `ValueConverterMap` – dictionary‑based replacement.
  - `ValueConverterShift` – cyclic array shift.
  - `ValueConverterSpring` – spring dynamics (smooth following).
  - `ValueConverterStack` – compose several converters into one.
  - `ValueConverterSwap` – toggle between two values.
- `NodePath` support – link nodes, objects contained in nodes and properties.

---

## Русский

> Набор инструментов для динамического преобразования и синхронизации свойств между объектами в Godot Engine.

### Возможности

- **PropertyDispatcher** – привязка свойства объекта к узлу с автоматическим чтением/записью.
- **PropertyConverter** – применение `ValueConverter` перед записью значения.
- **PropertyConverterStack** – цепочка конвертеров с записью результата в несколько целевых свойств.
- **Готовые ресурсы ValueConverter**:
  - `ValueConverterCurve` – преобразование через кривую `Curve`.
  - `ValueConverterExpression` – вычисление выражений GDScript (доступ к входному значению и синглтонам движка).
  - `ValueConverterMap` – замена по словарю.
  - `ValueConverterShift` – циклический сдвиг по массиву.
  - `ValueConverterSpring` – пружинная динамика (плавное следование).
  - `ValueConverterStack` – композиция нескольких конвертеров.
  - `ValueConverterSwap` – переключение между двумя значениями.
- Поддержка `NodePath` – связь узлов, объектов, содержащихся в узлах и свойств.
