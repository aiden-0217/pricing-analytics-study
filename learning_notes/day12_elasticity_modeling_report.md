# Analytical Report: Price Elasticity of Demand (PED)

**Date:** December 12, 2025
**Subject:** Pricing Strategy Analysis for Top Selling SKU (White Hanging Heart)
**Methodology:** Log-Log Linear Regression

---

## 1. Executive Summary
The primary objective of this analysis was to quantify consumer sensitivity to price changes for our highest-volume product. By applying a Log-Log regression model to daily aggregated sales data, we calculated a Price Elasticity of Demand (PED) coefficient of **-2.88**.

**Conclusion:** The product demand is **Highly Elastic** ($|\epsilon| > 1$). Consumers are extremely sensitive to price fluctuations, indicating that price is the dominant lever for controlling sales volume.

## 2. Model Results
* **Model Specification:** `log(DailyQuantity) ~ log(UnitPrice)`
* **Coefficient ($\beta$):** -2.88
* **Interpretation:** A **1% increase** in price is associated with an estimated **2.88% decrease** in quantity demanded. Conversely, a 1% price cut could generate a 2.88% uplift in volume.

## 3. Visual Interpretation of the Demand Curve
The regression plot visualizes the inverse relationship between Price and Quantity on a logarithmic scale:
* **Steep Downward Slope:** The steepness of the red regression line visually confirms the high elasticity. Small movements along the X-axis (Price) result in large movements along the Y-axis (Quantity).
* **Goodness of Fit:** The data points are clustered relatively closely to the regression line, suggesting that the model explains a significant portion of the variance in daily sales.

## 4. Strategic Recommendations
Based on the elasticity of -2.88, we recommend the following actions:

1.  **Avoid Price Hikes:** Do not increase the price. The potential loss in sales volume (~29% drop for a 10% hike) would likely result in a decrease in Total Revenue.
2.  **Leverage Promotions:** This product is an ideal candidate for **discount campaigns**. Since the volume response is strong, a temporary price reduction is likely to maximize Total Revenue and clear inventory efficiently.
3.  **Volume Driver Role:** Position this SKU as a "Traffic Builder" to attract price-sensitive customers, potentially cross-selling them with less elastic (higher margin) items.