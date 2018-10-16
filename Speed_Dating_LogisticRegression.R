
#separate by gender
ML_data_M <- SD_df[SD_df$gender == 'Male',] 

ML_data_F <- SD_df[SD_df$gender == 'Female',] 


#splitting data
train_F <- 
  ML_data_F %>% 
    select(dec:shar) %>% 
    slice(1:(nrow(ML_data_F)/2))
  
test_F <- 
  ML_data_F %>% 
  select(dec:shar) %>% 
  slice((nrow(ML_data_F)/2+1):nrow(ML_data_F))


train_M <- 
  ML_data_M %>% 
  select(dec:shar) %>% 
  slice(1:(nrow(ML_data_M)/2))

test_M <- 
  ML_data_M %>% 
  select(dec:shar) %>% 
  slice((nrow(ML_data_M)/2+1):nrow(ML_data_M))


#creating model
model_F <- glm(dec ~ ., family = binomial(link = "logit"), data = train_F)
summary(model_F)
anova(model_F, test="Chisq")

model_M <- glm(dec ~ ., family = binomial(link = "logit"), data = train_M)
summary(model_M)
anova(model_M, test="Chisq")

#testing/prediction of model
fitted_F <- predict(model_F, test_F, type="response")
fitted_F <- ifelse(fitted_F > 0.5,1,0)
misClasificError <- mean(fitted_F != test_F$dec)
print(paste('Accuracy',1-misClasificError))

fitted_M <- predict(model_M, test_M, type="response")
fitted_M <- ifelse(fitted_M > 0.5,1,0)
misClasificError <- mean(fitted_M != test_M$dec)
print(paste('Accuracy',1-misClasificError))

#testing one data point

library(ggradar)
library(scales)
library(fmsb)

user_df <- data.frame(sinc = 2, attr = 4, intel = 6, fun = 8, amb = 10, shar = 5)
user_df <- rbind(rep(10,6) , rep(0,6) , user_df) #adding upper and lower bounds
radarchart(user_df, axistype = 1,
           #custom the grid
           cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(2,10,2),
            #custom polygon
           pcol=rgb(0.2,0.8,0,0.9), pfcol=rgb(0.2,0.8,0,0.4) , plwd=2 , plty=1)
                

