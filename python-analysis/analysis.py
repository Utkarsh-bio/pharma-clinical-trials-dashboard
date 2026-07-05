import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('data/clinical_trials.csv')

print(df.head())
print(df.info())
# Success rate by phase
success_by_phase = df.groupby('phase')['is_success'].mean()
print("\nSuccess rate by phase:")
print(success_by_phase)

# Plot
plt.figure(figsize=(6,4))
success_by_phase.plot(kind='bar', color='steelblue')
plt.title('Success Rate by Trial Phase')
plt.ylabel('Success Rate')
plt.xlabel('Phase')
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig('success_by_phase.png')
plt.show()
# Success rate by sponsor (top 5)
success_by_sponsor = df.groupby('sponsor')['is_success'].mean().sort_values(ascending=False)
print("\nTop 5 sponsors by success rate:")
print(success_by_sponsor.head())

# Scatter: stock impact vs success
plt.figure(figsize=(6,4))
plt.scatter(df['estimated_stock_impact_pct'], df['is_success'], alpha=0.4, color='darkred')
plt.title('Stock Impact % vs Trial Success')
plt.xlabel('Estimated Stock Impact %')
plt.ylabel('Is Success (0/1)')
plt.tight_layout()
plt.savefig('stock_impact_vs_success.png')
plt.show()
import statsmodels.api as sm

# Encode phase as numeric for regression (Phase 2 = 0, Phase 3 = 1)
df['phase_encoded'] = df['phase'].map({'Phase 2': 0, 'Phase 3': 1})

# Build logistic regression: is_success ~ stock impact + phase + enrollment + duration
X = df[['estimated_stock_impact_pct', 'phase_encoded', 'enrollment_n', 'duration_months']]
X = sm.add_constant(X)  # adds intercept
y = df['is_success']

model = sm.Logit(y, X).fit()
print("\n--- Logistic Regression Summary ---")
print(model.summary())
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

X_ml = df[['estimated_stock_impact_pct', 'phase_encoded', 'enrollment_n', 'duration_months']]
y_ml = df['is_success']

X_train, X_test, y_train, y_test = train_test_split(X_ml, y_ml, test_size=0.2, random_state=42)

clf = LogisticRegression()
clf.fit(X_train, y_train)
y_pred = clf.predict(X_test)

print("\n--- ML Model Performance ---")
print("Accuracy:", accuracy_score(y_test, y_pred))
print("\nClassification Report:\n", classification_report(y_test, y_pred))
print("\nConfusion Matrix:\n", confusion_matrix(y_test, y_pred))
import numpy as np
coefficients = pd.Series(clf.coef_[0], index=X_ml.columns)
plt.figure(figsize=(6,4))
coefficients.sort_values().plot(kind='barh', color='teal')
plt.title('Feature Importance (Logistic Regression Coefficients)')
plt.tight_layout()
plt.savefig('feature_importance.png')
plt.show()