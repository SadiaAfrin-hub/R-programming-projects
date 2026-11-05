#1. read the dataset

students <- read.csv("students_data.csv")
head(students)











#2.Inspect the dataset
data(students)
str(students)
head(students)
summary(students)

# Create Total Marks
students$Total_Marks <- students$Quiz_Marks + 
  students$Assignment_Marks + 
  students$Midterm_Marks

# 4. Create a Grade variable using percentage
percentage <- (students$Total_Marks / 50) * 100
students$Grade <- ifelse(percentage >= 80, "A",
                         ifelse(percentage >= 70, "B",
                                ifelse(percentage >= 60, "C",
                                       ifelse(percentage >= 50, "D", "F"))))
# 5. Display summary statistics
print("Summary statistics:")
print(summary(students))
print("Average total marks:")
print(mean(students$Total_Marks))
print("Highest total marks:")
print(max(students$Total_Marks))
print("Lowest total marks:")
print(min(students$Total_Marks))
print("Number of students in each grade:")
print(table(students$Grade))
# 6. Save the updated dataset
write.csv(students, "final_results.csv", row.names = FALSE)
print("Updated dataset saved as final_results.csv")


