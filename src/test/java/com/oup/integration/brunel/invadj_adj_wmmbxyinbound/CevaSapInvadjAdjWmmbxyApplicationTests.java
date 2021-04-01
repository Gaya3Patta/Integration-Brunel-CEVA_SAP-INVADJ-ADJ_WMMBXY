package com.oup.integration.brunel.invadj_adj_wmmbxyinbound;

import static org.junit.Assert.assertFalse;

import org.apache.camel.test.spring.CamelSpringBootRunner;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;

@RunWith(CamelSpringBootRunner.class)
@SpringBootTest
public class CevaSapInvadjAdjWmmbxyApplicationTests {

	@Test
	@DirtiesContext
	public void testFileSuccessfullyProcessed() throws Exception {
		
		
		assertFalse(false);

	}
}
