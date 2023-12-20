package by.kni.alidada;

import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;

@SpringBootTest
@RunWith(SpringRunner.class)
@AutoConfigureMockMvc
class TestBuysellApplication {
  @Autowired
  private MockMvc mockMvc;

  @SneakyThrows
  @Test
  public void contextLoads() {
    //http://localhost:8089
    mockMvc.perform(get("/"))
            .andExpect(status().is3xxRedirection());
  }
}
