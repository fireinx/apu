import numpy as np
from tensorflow import keras
from keras import layers
import matplotlib.pyplot as plt

# Wczytanie danych MNIST
(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()

# Sprawdzenie kształtu danych
print(f"x_train shape: {x_train.shape}")
print(f"{x_train.shape[0]} train samples")
print(f"{x_test.shape[0]} test samples")

# Skalowanie obrazów do zakresu [0, 1]
x_train = x_train.astype("float32") / 255
x_test = x_test.astype("float32") / 255

# Upewnienie się, że obrazy mają kształt (28, 28, 1)
x_train = np.expand_dims(x_train, -1)
x_test = np.expand_dims(x_test, -1)

# Konwersja etykiet na macierze binarne klas
num_classes = 10
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

# Architektura modelu
model = keras.Sequential([
    keras.Input(shape=(28, 28, 1)),
    layers.Conv2D(32, kernel_size=(3, 3), activation="relu"),
    layers.MaxPooling2D(pool_size=(2, 2)),
    layers.Conv2D(64, kernel_size=(3, 3), activation="relu"),
    layers.MaxPooling2D(pool_size=(2, 2)),
    layers.Flatten(),
    layers.Dropout(0.5),
    layers.Dense(num_classes, activation="softmax")
])

# Wyświetlenie podsumowania modelu
model.summary()

# Kompilowanie modelu
model.compile(
    loss="categorical_crossentropy",
    optimizer="adam",
    metrics=["accuracy"]
)

# Trenowanie modelu
batch_size = 128
epochs = 15

history = model.fit(
    x_train, y_train,
    batch_size=batch_size,
    epochs=epochs,
    validation_split=0.1
)

# Ocena modelu na zbiorze testowym
score = model.evaluate(x_test, y_test, verbose=0)
print(f"Test loss: {score[0]}")
print(f"Test accuracy: {score[1]}")

# Prognozowanie nowych danych
predictions = model.predict(x_test)

# Wyświetlenie przykładowego obrazu z jego przewidywaną klasą
plt.figure(figsize=(10, 5))
for i in range(10):
    plt.subplot(2, 5, i+1)
    plt.imshow(x_test[i].reshape(28, 28), cmap='gray')
    plt.title(f"Label: {np.argmax(y_test[i])}\nPred: {np.argmax(predictions[i])}")
    plt.axis('off')
plt.show()
